"use strict";

const assert = require("node:assert/strict");
const {
  describe,
  it,
} = require("node:test");

const {_test} = require("../text_to_speech");

describe("textToSpeech helpers", () => {
  it("picks audio file extensions from content type and output format", () => {
    assert.equal(
      _test.pickFileExt({
        contentType: "audio/mpeg",
        outputFormat: "",
      }),
      "mp3",
    );
    assert.equal(
      _test.pickFileExt({
        contentType: "application/octet-stream",
        outputFormat: "wav_44100",
      }),
      "wav",
    );
  });

  it("normalizes text fields", () => {
    assert.equal(_test.textValue(" voice "), "voice");
    assert.equal(_test.textValue(null), "");
  });

  it("sanitizes supported voice settings and rejects invalid values", () => {
    assert.deepEqual(
      _test.sanitizeVoiceSettings({
        stability: 0.5,
        similarity_boost: 1,
        style: 0,
        use_speaker_boost: true,
        ignored: "value",
      }),
      {
        stability: 0.5,
        similarity_boost: 1,
        style: 0,
        use_speaker_boost: true,
      },
    );
    assert.equal(_test.sanitizeVoiceSettings({ignored: "value"}), undefined);
    assert.throws(
      () => _test.sanitizeVoiceSettings({stability: 2}),
      /Invalid voice_settings.stability/,
    );
  });

  it("validates voice ids against format and allowlist", async () => {
    await assert.rejects(
      () => _test.verifyVoiceId("bad id", {
        verifyVoiceId: async () => true,
      }),
      /Unsupported voiceid/,
    );
    await assert.rejects(
      () => _test.verifyVoiceId("voice_1", {
        verifyVoiceId: async () => false,
      }),
      /Voice is not allowlisted/,
    );
    await assert.doesNotReject(
      () => _test.verifyVoiceId("voice_1", {
        allowedVoiceIds: new Set(["voice_1"]),
      }),
    );
  });

  it("builds quota usage and rejects exhausted daily limits", () => {
    assert.deepEqual(
      _test.buildTtsQuotaUsage(
        {calls: 1, chars: 9},
        10,
        {dailyCallLimit: 3, dailyCharLimit: 20},
      ),
      {calls: 2, chars: 19},
    );
    assert.throws(
      () => _test.buildTtsQuotaUsage(
        {calls: 3, chars: 9},
        1,
        {dailyCallLimit: 3, dailyCharLimit: 20},
      ),
      /Text-to-speech daily limit exceeded/,
    );
    assert.throws(
      () => _test.buildTtsQuotaUsage(
        {calls: 1, chars: 19},
        2,
        {dailyCallLimit: 3, dailyCharLimit: 20},
      ),
      /Text-to-speech daily limit exceeded/,
    );
  });

  it("synthesizes speech with mocked provider and storage clients", async () => {
    const saved = {};
    const fakeFetch = async (url, options) => {
      saved.url = url;
      saved.request = JSON.parse(options.body);
      return {
        ok: true,
        headers: {
          get: () => "audio/mpeg",
        },
        arrayBuffer: async () => Uint8Array.from([1, 2, 3]).buffer,
      };
    };
    const fakeStorage = {
      bucket: (bucketName) => {
        saved.bucketName = bucketName;
        return {
          file: (objectPath) => {
            saved.objectPath = objectPath;
            return {
              save: async (buffer, options) => {
                saved.buffer = buffer;
                saved.saveOptions = options;
              },
            };
          },
        };
      },
    };
    const ids = ["file-id", "download-token"];
    const result = await _test.synthesizeSpeech(
      {
        text: "hello",
        voiceid: "voice_1",
        modelid: "eleven_multilingual_v2",
        outputformat: "mp3_44100_128",
      },
      {
        elevenLabsKey: "test-key",
        bucketName: "test-bucket",
        fetchImpl: fakeFetch,
        skipQuota: true,
        storageClient: fakeStorage,
        now: () => 123,
        uuidFactory: () => ids.shift(),
        verifyVoiceId: async () => true,
      },
    );

    assert.equal(
      saved.url,
      "https://api.elevenlabs.io/v1/text-to-speech/voice_1",
    );
    assert.deepEqual(saved.request, {
      text: "hello",
      model_id: "eleven_multilingual_v2",
      output_format: "mp3_44100_128",
    });
    assert.equal(saved.bucketName, "test-bucket");
    assert.equal(saved.objectPath, "tts/123-file-id.mp3");
    assert.equal(saved.buffer.length, 3);
    assert.equal(
      saved.saveOptions.metadata.metadata.firebaseStorageDownloadTokens,
      "download-token",
    );
    assert.equal(
      result.audiopath,
      "https://firebasestorage.googleapis.com/v0/b/test-bucket/o/tts%2F123-file-id.mp3?alt=media&token=download-token",
    );
  });

  it("rejects oversized text before provider calls", async () => {
    await assert.rejects(
      () => _test.synthesizeSpeech(
        {
          text: "abcdef",
          voiceid: "voice_1",
        },
        {
          elevenLabsKey: "test-key",
          bucketName: "test-bucket",
          maxTextChars: 5,
          skipQuota: true,
          verifyVoiceId: async () => true,
          fetchImpl: async () => {
            throw new Error("fetch should not run");
          },
        },
      ),
      /Text is too long/,
    );
  });

  it("rejects unsupported model and output format before provider calls", async () => {
    await assert.rejects(
      () => _test.synthesizeSpeech(
        {
          text: "hello",
          voiceid: "voice_1",
          modelid: "other_model",
        },
        {
          elevenLabsKey: "test-key",
          bucketName: "test-bucket",
          skipQuota: true,
          verifyVoiceId: async () => true,
          fetchImpl: async () => {
            throw new Error("fetch should not run");
          },
        },
      ),
      /Unsupported modelid/,
    );
    await assert.rejects(
      () => _test.synthesizeSpeech(
        {
          text: "hello",
          voiceid: "voice_1",
          outputformat: "pcm_24000",
        },
        {
          elevenLabsKey: "test-key",
          bucketName: "test-bucket",
          skipQuota: true,
          verifyVoiceId: async () => true,
          fetchImpl: async () => {
            throw new Error("fetch should not run");
          },
        },
      ),
      /Unsupported outputformat/,
    );
  });

  it("maps provider failures to callable errors", async () => {
    await assert.rejects(
      () => _test.synthesizeSpeech(
        {
          text: "hello",
          voiceid: "voice_1",
        },
        {
          elevenLabsKey: "test-key",
          bucketName: "test-bucket",
          skipQuota: true,
          verifyVoiceId: async () => true,
          fetchImpl: async () => ({
            ok: false,
            status: 429,
          }),
        },
      ),
      /ElevenLabs request failed: 429/,
    );
  });
});
