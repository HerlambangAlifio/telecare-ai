const assert = require("node:assert/strict");
const { once } = require("node:events");
const { test } = require("node:test");

const app = require("./server");

test("rejects incomplete symptom data", async (t) => {
  const server = app.listen(0);
  await once(server, "listening");
  t.after(() => new Promise((resolve) => server.close(resolve)));

  const response = await fetch(`http://127.0.0.1:${server.address().port}/chat`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ complaint: " " }),
  });

  assert.equal(response.status, 400);
});

test("reports missing xAI configuration without calling the provider", async (t) => {
  const originalKey = process.env.XAI_API_KEY;
  process.env.XAI_API_KEY = "";
  t.after(() => {
    if (originalKey === undefined) {
      delete process.env.XAI_API_KEY;
    } else {
      process.env.XAI_API_KEY = originalKey;
    }
  });

  const server = app.listen(0);
  await once(server, "listening");
  t.after(() => new Promise((resolve) => server.close(resolve)));

  const response = await fetch(`http://127.0.0.1:${server.address().port}/chat`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      complaint: "batuk",
      duration: "1-3 hari",
      frequency: "Kadang-kadang",
      detail: "",
    }),
  });

  assert.equal(response.status, 503);
});

test("sends a non-stored request to xAI and returns generated text", async (t) => {
  const originalKey = process.env.XAI_API_KEY;
  const originalFetch = global.fetch;
  let requestBody;
  process.env.XAI_API_KEY = "test-only-key";
  global.fetch = async (url, options) => {
    if (url !== "https://api.x.ai/v1/responses") {
      return originalFetch(url, options);
    }
    assert.equal(url, "https://api.x.ai/v1/responses");
    assert.equal(options.headers.Authorization, "Bearer test-only-key");
    requestBody = JSON.parse(options.body);
    return new Response(
      JSON.stringify({
        output: [
          {
            content: [{ type: "output_text", text: "Jawaban edukasi uji." }],
          },
        ],
      }),
      { status: 200, headers: { "Content-Type": "application/json" } },
    );
  };
  t.after(() => {
    global.fetch = originalFetch;
    if (originalKey === undefined) {
      delete process.env.XAI_API_KEY;
    } else {
      process.env.XAI_API_KEY = originalKey;
    }
  });

  const server = app.listen(0);
  await once(server, "listening");
  t.after(() => new Promise((resolve) => server.close(resolve)));

  const response = await fetch(`http://127.0.0.1:${server.address().port}/chat`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      complaint: "batuk",
      duration: "1-3 hari",
      frequency: "Kadang-kadang",
      detail: "",
    }),
  });

  assert.equal(response.status, 200);
  assert.deepEqual(await response.json(), { reply: "Jawaban edukasi uji." });
  assert.equal(requestBody.model, process.env.XAI_MODEL || "grok-4.7");
  assert.equal(requestBody.store, false);
});
