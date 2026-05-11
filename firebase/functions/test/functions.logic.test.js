const assert = require("node:assert/strict");
const {
  describe,
  it,
} = require("node:test");

const {_test} = require("../index.js");
const {AGENT_CONFIGS} = require("../agent_configs.js");
const {_test: shareTest} = require("../share_roast.js");

const fieldValue = {
  delete: () => ({op: "delete"}),
  increment: (value) => ({op: "increment", value}),
};

describe("Functions business logic", () => {
  it("resolves an active RevenueCat entitlement into a local plan", () => {
    const entitlement = _test.resolveActiveEntitlement(
      {
        entitlements: {
          Premium: {
            product_identifier: "roast_99_1year",
            purchase_date: "2026-05-01T00:00:00Z",
            expires_date: "2027-05-01T00:00:00Z",
          },
        },
      },
      "Premium",
      new Date("2026-05-10T00:00:00Z"),
    );

    assert.equal(entitlement.plan, "yearly");
    assert.equal(entitlement.productIdentifier, "roast_99_1year");
    assert.equal(entitlement.purchaseDate.toISOString(), "2026-05-01T00:00:00.000Z");
    assert.equal(entitlement.expiresAt.toISOString(), "2027-05-01T00:00:00.000Z");
  });

  it("rejects expired RevenueCat entitlements", () => {
    const entitlement = _test.resolveActiveEntitlement(
      {
        entitlements: {
          Premium: {
            product_identifier: "roast_9_1Month",
            purchase_date: "2026-04-01T00:00:00Z",
            expires_date: "2026-05-01T00:00:00Z",
          },
        },
      },
      "Premium",
      new Date("2026-05-10T00:00:00Z"),
    );

    assert.equal(entitlement, null);
  });

  it("builds subscription updates with server-owned protected fields", () => {
    const update = _test.subscriptionUpdateForEntitlement(
      {
        plan: "monthly",
        purchaseDate: new Date("2026-05-01T00:00:00Z"),
        expiresAt: new Date("2026-06-01T00:00:00Z"),
      },
      fieldValue,
    );

    assert.equal(update.SubPlan, "monthly");
    assert.equal(update.dateSubStart.toISOString(), "2026-05-01T00:00:00.000Z");
    assert.equal(update.dateSubEnd.toISOString(), "2026-06-01T00:00:00.000Z");
    assert.deepEqual(update.count_limited, {op: "delete"});
    assert.deepEqual(update.count_limited_chat, {op: "delete"});
  });

  it("records included usage before the active premium quota is reached", () => {
    const mutation = _test.buildUsageUpdate(
      {
        SubPlan: "monthly",
        dateSubEnd: new Date("2026-06-01T00:00:00Z"),
        count_limited_chat: 299,
        extra_chat: 3,
      },
      "chat",
      fieldValue,
      new Date("2026-05-10T00:00:00Z"),
    );

    assert.deepEqual(mutation.update, {
      count_limited_chat: {op: "increment", value: 1},
    });
    assert.deepEqual(mutation.result, {
      feature: "chat",
      mode: "included",
      usedCount: 300,
      includedLimit: 300,
      extraCredits: 3,
    });
  });

  it("uses extra credits after included usage is exhausted", () => {
    const mutation = _test.buildUsageUpdate(
      {
        count_limited: 18,
        extra_photo: 2,
      },
      "roast",
      fieldValue,
      new Date("2026-05-10T00:00:00Z"),
    );

    assert.deepEqual(mutation.update, {
      extra_photo: {op: "increment", value: -1},
    });
    assert.equal(mutation.result.mode, "extra_credit");
    assert.equal(mutation.result.extraCredits, 1);
  });

  it("throws when usage quota and extra credits are exhausted", () => {
    assert.throws(
      () => _test.buildUsageUpdate(
        {
          count_limited_chat: 18,
          extra_chat: 0,
        },
        "chat",
        fieldValue,
        new Date("2026-05-10T00:00:00Z"),
      ),
      /Usage limit exceeded/,
    );
  });

  it("builds daily AI rate limit usage and rejects exhausted limits", () => {
    assert.deepEqual(
      _test.buildDailyRateLimitUsage({calls: 2}, 3),
      {calls: 3},
    );
    assert.throws(
      () => _test.buildDailyRateLimitUsage({calls: 3}, 3),
      /Daily AI request limit exceeded/,
    );
  });

  it("finds only unsynced reload pack purchases", () => {
    const purchases = _test.reloadPurchasesAfter(
      {
        non_subscriptions: {
          Roast_Reload_Pack: [
            {id: "old", purchase_date: "2026-05-01T00:00:00Z"},
            {id: "new-2", purchase_date: "2026-05-03T00:00:00Z"},
            {id: "new-1", purchase_date: "2026-05-02T00:00:00Z"},
          ],
        },
      },
      "Roast_Reload_Pack",
      new Date("2026-05-01T12:00:00Z"),
    );

    assert.deepEqual(purchases.map((purchase) => purchase.id), [
      "new-1",
      "new-2",
    ]);
  });

  it("sanitizes client request ids for logs", () => {
    assert.equal(
      _test.clientRequestId({_clientRequestId: "chat req/1"}),
      "chat_req_1",
    );
    assert.equal(_test.clientRequestId({}), "missing");
    assert.equal(_test.clientRequestId({_clientRequestId: ""}), "missing");
  });

  it("builds safe error log metadata without raw error objects", () => {
    const log = _test.safeErrorLogMetadata(
      "syncRevenueCatSubscription",
      "req_1",
      new Error("secret-bearing axios error"),
    );

    assert.deepEqual(log, {
      functionName: "syncRevenueCatSubscription",
      requestId: "req_1",
      code: "internal",
      message: "secret-bearing axios error",
    });
  });

  it("keeps AI agent configs available without embedded API keys", () => {
    assert.equal(AGENT_CONFIGS.roast.aiModel.model, "gpt-4o");
    assert.equal(AGENT_CONFIGS.aIAssistent.responseOptions.responseType, "PLAINTEXT");
    assert.doesNotMatch(JSON.stringify(AGENT_CONFIGS), /sk-[A-Za-z0-9_-]+/);
    assert.doesNotMatch(JSON.stringify(AGENT_CONFIGS), /appl_[A-Za-z0-9]+/);
  });

  it("builds stable share ids and extracts share route ids", () => {
    assert.equal(
      shareTest.buildStableShareId("uid", "AddedDishHistory/dish"),
      shareTest.buildStableShareId("uid", "AddedDishHistory/dish"),
    );
    assert.equal(shareTest.extractShareId("/r/share-id?x=1"), "share-id");
    assert.equal(shareTest.extractShareId("/missing/share-id"), "");
  });

  it("runs the roast agent with a mocked OpenAI client", async () => {
    let capturedParams;
    const fakeOpenAi = {
      responses: {
        create: async (params) => {
          capturedParams = params;
          return {
            id: "resp_1",
            output_text: "{\"roast\":\"ok\"}",
          };
        },
      },
    };

    const result = await _test.runOpenAiAgent(
      "roast",
      {message: "dish_name=test"},
      {openaiClient: fakeOpenAi},
    );

    assert.deepEqual(result, {
      response: "{\"roast\":\"ok\"}",
      responseId: "resp_1",
    });
    assert.equal(capturedParams.model, "gpt-4o");
    assert.deepEqual(capturedParams.text, {format: {type: "json_object"}});
    assert.equal(capturedParams.input.at(-1).role, "user");
    assert.deepEqual(capturedParams.input.at(-1).content, [
      {type: "input_text", text: "dish_name=test"},
    ]);
  });

  it("extracts OpenAI output text from content arrays", () => {
    assert.equal(
      _test.extractOpenAiOutputText({
        output: [
          {
            content: [
              {text: "hello"},
              {text: "world"},
            ],
          },
        ],
      }),
      "hello\nworld",
    );
  });

  it("rejects empty AI agent input before provider calls", async () => {
    await assert.rejects(
      () => _test.runOpenAiAgent(
        "aIAssistent",
        {message: "   "},
        {
          openaiClient: {
            responses: {
              create: async () => ({id: "unused", output_text: ""}),
            },
          },
        },
      ),
      /Message or imageUrl is required/,
    );
  });
});
