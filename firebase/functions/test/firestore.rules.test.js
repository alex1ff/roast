const { strictEqual } = require("node:assert");
const { readFileSync } = require("node:fs");
const { resolve } = require("node:path");
const {
  after,
  before,
  beforeEach,
  describe,
  it,
} = require("node:test");

const {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} = require("@firebase/rules-unit-testing");
const {
  deleteField,
  deleteDoc,
  doc,
  getDoc,
  setDoc,
  updateDoc,
} = require("firebase/firestore");

describe("Firestore security rules", { timeout: 15000 }, () => {
  let testEnv;

  before(async () => {
    testEnv = await initializeTestEnvironment({
      projectId: process.env.GCLOUD_PROJECT || "demo-roast",
      firestore: {
        rules: readFileSync(resolve(__dirname, "../../firestore.rules"), "utf8"),
      },
    });
  });

  beforeEach(async () => {
    await testEnv.clearFirestore();
  });

  after(async () => {
    await testEnv.cleanup();
  });

  const dbFor = (uid) => testEnv.authenticatedContext(uid).firestore();
  const guestDb = () => testEnv.unauthenticatedContext().firestore();

  it("restricts users documents to their owner", async () => {
    const aliceDb = dbFor("alice");
    const bobDb = dbFor("bob");
    const aliceDoc = doc(aliceDb, "users/alice");

    await assertSucceeds(
      setDoc(aliceDoc, { uid: "alice", display_name: "Alice" }),
    );
    await assertSucceeds(getDoc(aliceDoc));
    await assertFails(getDoc(doc(bobDb, "users/alice")));
    await assertFails(
      setDoc(doc(guestDb(), "users/guest"), { uid: "guest" }),
    );
    await assertFails(
      updateDoc(doc(bobDb, "users/alice"), { display_name: "Bob" }),
    );
    await assertFails(deleteDoc(doc(bobDb, "users/alice")));
  });

  it("prevents client-side subscription and limit tampering", async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      const db = context.firestore();

      await setDoc(doc(db, "users/alice"), {
        uid: "alice",
        display_name: "Alice",
        count_limited: 1,
        count_limited_chat: 2,
        dateSubEnd: new Date("2026-06-10T00:00:00.000Z"),
        SubPlan: "monthly",
        extra_chat: 0,
      });
      await setDoc(doc(db, "users/bob"), {
        uid: "bob",
        display_name: "Bob",
      });
    });

    const aliceDb = dbFor("alice");
    const aliceDoc = doc(aliceDb, "users/alice");
    const bobDoc = doc(dbFor("bob"), "users/bob");

    await assertSucceeds(updateDoc(aliceDoc, { display_name: "Alice A." }));
    await assertFails(updateDoc(aliceDoc, { count_limited: 2 }));
    await assertFails(updateDoc(aliceDoc, { count_limited_chat: 3 }));
    await assertFails(updateDoc(bobDoc, { count_limited: 1 }));
    await assertFails(updateDoc(bobDoc, { count_limited_chat: 3 }));
    await assertFails(updateDoc(aliceDoc, { count_limited: 0 }));
    await assertFails(updateDoc(aliceDoc, { count_limited_chat: 99 }));
    await assertFails(updateDoc(aliceDoc, { count_limited: deleteField() }));
    await assertFails(
      updateDoc(aliceDoc, {
        dateSubEnd: new Date("2027-06-10T00:00:00.000Z"),
      }),
    );
    await assertFails(updateDoc(aliceDoc, { SubPlan: "yearly" }));
    await assertFails(updateDoc(aliceDoc, { extra_chat: 25 }));
  });

  it("restricts AddedDishHistory documents to their owner reference", async () => {
    const aliceDb = dbFor("alice");
    const bobDb = dbFor("bob");
    const aliceDish = doc(aliceDb, "AddedDishHistory/dish1");

    await assertSucceeds(
      setDoc(aliceDish, {
        dish_name: "Soup",
        user: doc(aliceDb, "users/alice"),
      }),
    );
    await assertSucceeds(getDoc(aliceDish));
    await assertFails(getDoc(doc(bobDb, "AddedDishHistory/dish1")));
    await assertFails(getDoc(doc(guestDb(), "AddedDishHistory/dish1")));
    await assertFails(
      setDoc(doc(bobDb, "AddedDishHistory/dish2"), {
        dish_name: "Wrong owner",
        user: doc(bobDb, "users/alice"),
      }),
    );
    await assertSucceeds(updateDoc(aliceDish, { dish_name: "Updated soup" }));
    await assertFails(
      updateDoc(aliceDish, { user: doc(aliceDb, "users/bob") }),
    );
  });

  it("lets service/admin contexts seed protected documents", async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      const db = context.firestore();

      await setDoc(doc(db, "users/service-user"), {
        uid: "service-user",
        chat_limit: 100,
      });
      await setDoc(doc(db, "AddedDishHistory/admin-dish"), {
        dish_name: "Backend dish",
        user: doc(db, "users/service-user"),
      });
    });

    const serviceDb = dbFor("service-user");
    const userSnap = await getDoc(doc(serviceDb, "users/service-user"));
    const dishSnap = await getDoc(
      doc(serviceDb, "AddedDishHistory/admin-dish"),
    );

    strictEqual(userSnap.exists(), true);
    strictEqual(dishSnap.exists(), true);
  });
});
