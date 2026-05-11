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
        storageClient: fakeStorage,
        now: () => 123,
        uuidFactory: () => ids.shift(),
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
          fetchImpl: async () => {
            throw new Error("fetch should not run");
          },
        },
      ),
      /Text is too long/,
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
