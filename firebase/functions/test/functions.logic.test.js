const assert = require("node:assert/strict");
const {
  describe,
  it,
} = require("node:test");

const {_test} = require("../index.js");
const {AGENT_CONFIGS} = require("../agent_configs.js");
const {
  ROAST_PERSONAS,
  resolveRoastPersona,
} = require("../roast_personas.js");
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

  it("resolves weekly RevenueCat product into weekly SubPlan", () => {
    const entitlement = _test.resolveActiveEntitlement(
      {
        entitlements: {
          Premium: {
            product_identifier: "roast_99_1week",
            purchase_date: "2026-05-01T00:00:00Z",
            expires_date: "2026-05-08T00:00:00Z",
          },
        },
      },
      "Premium",
      new Date("2026-05-02T00:00:00Z"),
    );

    assert.equal(entitlement.plan, "weekly");
    assert.equal(entitlement.productIdentifier, "roast_99_1week");
    assert.equal(entitlement.expiresAt.toISOString(), "2026-05-08T00:00:00.000Z");
  });

  it("falls back to a seven day subscription end from sync time", () => {
    const entitlement = _test.resolveActiveEntitlement(
      {
        entitlements: {
          Premium: {
            product_identifier: "roast_99_1week",
            purchase_date: "2026-05-01T00:00:00Z",
          },
        },
      },
      "Premium",
      new Date("2026-05-02T00:00:00Z"),
    );

    assert.equal(entitlement.plan, "weekly");
    assert.equal(entitlement.expiresAt.toISOString(), "2026-05-09T00:00:00.000Z");
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

  it("writes weekly SubPlan in subscription updates", () => {
    const update = _test.subscriptionUpdateForEntitlement(
      {
        plan: "weekly",
        purchaseDate: new Date("2026-05-01T00:00:00Z"),
        expiresAt: new Date("2026-05-08T00:00:00Z"),
      },
      fieldValue,
    );

    assert.equal(update.SubPlan, "weekly");
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

  it("uses weekly included usage limit for active weekly plans", () => {
    const mutation = _test.buildUsageUpdate(
      {
        SubPlan: "weekly",
        dateSubEnd: new Date("2026-05-17T00:00:00Z"),
        count_limited_chat: 24,
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
      usedCount: 25,
      includedLimit: 25,
      extraCredits: 3,
    });
  });

  it("uses a shared free quota across roast and chat", () => {
    assert.throws(
      () => _test.buildUsageUpdate(
        {
          count_limited: 2,
          count_limited_chat: 1,
          extra_photo: 0,
        },
        "roast",
        fieldValue,
        new Date("2026-05-10T00:00:00Z"),
      ),
      /Usage limit exceeded/,
    );

    const mutation = _test.buildUsageUpdate(
      {
        count_limited: 1,
        count_limited_chat: 1,
      },
      "chat",
      fieldValue,
      new Date("2026-05-10T00:00:00Z"),
    );

    assert.deepEqual(mutation.update, {
      count_limited_chat: {op: "increment", value: 1},
    });
    assert.equal(mutation.result.usedCount, 3);
    assert.equal(mutation.result.includedLimit, 3);
  });

  it("uses extra credits after included usage is exhausted", () => {
    const mutation = _test.buildUsageUpdate(
      {
        SubPlan: "monthly",
        dateSubEnd: new Date("2026-06-01T00:00:00Z"),
        count_limited: 280,
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

  it("does not allow free users to bypass the shared quota with extras", () => {
    assert.throws(
      () => _test.buildUsageUpdate(
        {
          count_limited: 3,
          extra_photo: 2,
        },
        "roast",
        fieldValue,
        new Date("2026-05-10T00:00:00Z"),
      ),
      /Usage limit exceeded/,
    );
  });

  it("throws when usage quota and extra credits are exhausted", () => {
    assert.throws(
      () => _test.buildUsageUpdate(
        {
          count_limited_chat: 3,
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

  it("renders share page with roast back CTAs before roast copy", () => {
    const html = shareTest.renderSharePage(
      {
        title: "Pasta got roasted",
        excerpt: "shared",
        content: "Too much drama for one bowl.",
        dishName: "Pasta",
        itemImageUrl: "https://example.com/pasta.jpg",
        audioUrl: "https://example.com/roast.mp3",
        kcal: 520,
        proteins: 20,
        fats: 18,
        carbs: 64,
      },
      "share-id",
    );

    assert.equal((html.match(/Roast Back/g) || []).length, 2);
    assert.match(html, /Don’t just take it! Roast back!/);
    assert.match(
      html,
      /Get Roast Them All app &amp; start the chaos: roast friends, dishes, or whatever you want\./,
    );

    const bodyIndex = html.indexOf("<body>");
    const imageIndex = html.indexOf("class=\"hero-image\"", bodyIndex);
    const audioIndex = html.indexOf("class=\"audio-card\"", bodyIndex);
    const topCtaIndex = html.indexOf(
      "class=\"store-button top-cta\"",
      bodyIndex,
    );
    const roastIndex = html.indexOf("class=\"roast-bubble\"", bodyIndex);
    const nutritionIndex = html.indexOf(
      "class=\"nutrition-grid\"",
      bodyIndex,
    );

    assert.ok(imageIndex > -1);
    assert.ok(imageIndex < audioIndex);
    assert.ok(audioIndex < topCtaIndex);
    assert.ok(topCtaIndex < roastIndex);
    assert.ok(roastIndex < nutritionIndex);
  });

  it("renders non-nutrition share page without goal or macro copy", () => {
    const html = shareTest.renderSharePage(
      {
        title: "Sam got congraturoasted",
        excerpt: "shared",
        content: "Happy birthday. Your scheduling skills remain on airplane mode.",
        dishName: "Sam",
        itemImageUrl: "https://example.com/sam.jpg",
        roastMode: "congratu_roast",
        occasionLabel: "Birthday",
        subjectType: "person",
        showNutrition: false,
        kcal: 520,
        proteins: 20,
        fats: 18,
        carbs: 64,
        impact: "Impact on your goal: On track",
        calorieShare: "This alone = 32% of your daily calories",
      },
      "share-id",
    );

    assert.doesNotMatch(html, /class="nutrition-grid"/);
    assert.doesNotMatch(html, /Kcal/);
    assert.doesNotMatch(html, /Proteins/);
    assert.doesNotMatch(html, /daily calories/);
    assert.doesNotMatch(html, /Impact on your goal/);
    assert.match(html, /Birthday/);
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

  it("stores structured roast personas", () => {
    assert.equal(Object.keys(ROAST_PERSONAS).length, 30);
    assert.equal(resolveRoastPersona("Snack Shady").id, "snack_shady");
    assert.equal(resolveRoastPersona("Breadpool").id, "breadfool");
    assert.equal(resolveRoastPersona("Iron Pan").id, "iron_pan");
    assert.equal(resolveRoastPersona("Southie Beefcake").id, "southie_beefcake");
    assert.equal(resolveRoastPersona("Bro Lebunski").id, "bro_lebunski");
    assert.equal(resolveRoastPersona("Carbface").id, "carbface");
    assert.equal(resolveRoastPersona("Ivan the Enforcer").id, "bro_lebunski");
    assert.equal(resolveRoastPersona("Tyler Sweets").id, "carbface");
    assert.equal(resolveRoastPersona("Lil Green Roastmaster").id, "lil_green_roastmaster");
    assert.equal(resolveRoastPersona("Jo-Da, Lil Green Roastmaster").id, "lil_green_roastmaster");
    assert.notEqual(resolveRoastPersona("The Orange Deal Maker").id, "wolf_wrap_street");
    assert.notEqual(resolveRoastPersona("Gordon Rant-say").id, "wolf_wrap_street");
    assert.notEqual(resolveRoastPersona("Snackye West").id, "wolf_wrap_street");
  });

  it("injects only the selected roast persona into the roast prompt", () => {
    const systemMessage = _test.getSystemMessage(
      AGENT_CONFIGS.roast.aiModel.messages,
      "JSON",
      "roast",
      {
        message: "call_type=analyze; roast_persona_id=snack_shady; roast_persona=Snack Shady;",
      },
    );

    assert.match(systemMessage, /SELECTED ROAST PERSONA/);
    assert.match(systemMessage, /Name: Snack Shady/);
    assert.match(systemMessage, /"roast_persona_id": "<selected persona id>"/);
    assert.doesNotMatch(systemMessage, /Snackwolf of Wall Street/);
    assert.doesNotMatch(systemMessage, /Wolf of Wrap Street/);
    assert.doesNotMatch(systemMessage, /Fight Bite Dana \|/);
  });

  it("documents congraturoast mode and bans nutrition language for it", () => {
    const systemMessage = _test.getSystemMessage(
      AGENT_CONFIGS.roast.aiModel.messages,
      "JSON",
      "roast",
      {
        message: "call_type=congratu_roast; occasion_key=birthday; occasion_label=Birthday; roast_persona_id=snack_shady;",
      },
    );

    assert.match(systemMessage, /congratu_roast/);
    assert.match(systemMessage, /occasion_key/);
    assert.match(systemMessage, /90% congratulations/i);
    assert.match(systemMessage, /10% friendly roast/i);
    assert.match(systemMessage, /show_nutrition/);
    assert.match(systemMessage, /must be false/);
    const personaBlock = systemMessage.split("SELECTED ROAST PERSONA:").at(-1);
    assert.doesNotMatch(personaBlock, /macro|calorie|kcal|protein|carb|sodium/i);
    assert.doesNotMatch(personaBlock, /meal|dish|plate|food decision/i);
  });

  it("extends Smart Chat for social roast prompts", async () => {
    let capturedParams;
    const fakeOpenAi = {
      responses: {
        create: async (params) => {
          capturedParams = params;
          return {
            id: "resp_2",
            output_text: "Roast: ok",
          };
        },
      },
    };

    await _test.runOpenAiAgent(
      "aIAssistent",
      {message: "My friend started a crypto podcast after losing money."},
      {openaiClient: fakeOpenAi},
    );

    assert.match(capturedParams.instructions, /RealTalk with Elena/);
    assert.match(capturedParams.instructions, /roasting friends/);
    assert.match(capturedParams.instructions, /do not force nutrition/);
    assert.match(capturedParams.instructions, /final line starting with 'Roast: '/);
    assert.equal(capturedParams.input.at(-1).role, "user");
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
