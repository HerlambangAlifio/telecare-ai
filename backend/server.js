
const path = require("node:path");
require("dotenv").config({ path: path.join(__dirname, ".env") });

const express = require("express");

const app = express();
app.use(express.json({ limit: "10kb" }));

app.get("/", (_req, res) => {
  res.json({ status: "Backend TeleCare AI aktif" });
});

app.post("/chat", async (req, res) => {
  const { complaint, duration, frequency, detail = "" } = req.body ?? {};

  if (
    typeof complaint !== "string" ||
    !complaint.trim() ||
    complaint.length > 300 ||
    typeof duration !== "string" ||
    !duration.trim() ||
    duration.length > 50 ||
    typeof frequency !== "string" ||
    !frequency.trim() ||
    frequency.length > 50 ||
    typeof detail !== "string" ||
    detail.length > 200
  ) {
    return res.status(400).json({ error: "Data keluhan tidak valid." });
  }

  if (!process.env.XAI_API_KEY) {
    return res.status(503).json({
      error: "Backend belum dikonfigurasi dengan XAI_API_KEY.",
    });
  }

  try {
    const response = await fetch("https://api.x.ai/v1/responses", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${process.env.XAI_API_KEY}`,
        "Content-Type": "application/json",
      },
      signal: AbortSignal.timeout(60000),
      body: JSON.stringify({
        model: process.env.XAI_MODEL || "grok-4.7",
        store: false,
        instructions:
          "Kamu adalah TeleCare AI, asisten edukasi kesehatan berbahasa Indonesia. " +
          "Berikan informasi umum yang ringkas, empatik, dan mudah dipahami; " +
          "jangan mendiagnosis, meresepkan obat atau dosis, atau mengaku sebagai dokter. " +
          "Sebutkan bahwa informasi ini bukan pengganti pemeriksaan tenaga kesehatan. " +
          "Jika ada tanda bahaya seperti sesak napas berat, nyeri dada, pingsan, " +
          "penurunan kesadaran, kejang, atau batuk darah, utamakan anjuran mencari " +
          "pertolongan medis darurat.",
        input:
          `Keluhan utama: ${complaint.trim()}\n` +
          `Durasi: ${duration.trim()}\n` +
          `Frekuensi: ${frequency.trim()}\n` +
          `Keterangan tambahan: ${detail.trim() || "Tidak ada"}`,
        max_output_tokens: 500,
      }),
    });

    if (!response.ok) {
      console.error(`xAI request failed with status ${response.status}`);
      return res.status(502).json({
        error: "Grok tidak dapat memberikan jawaban saat ini.",
      });
    }

    const result = await response.json();
    const reply = (result.output ?? [])
      .flatMap((item) => item.content ?? [])
      .filter((item) => item.type === "output_text")
      .map((item) => item.text)
      .join("\n")
      .trim();

    if (!reply) {
      console.error("xAI response did not contain output text");
      return res.status(502).json({
        error: "Grok tidak mengembalikan jawaban yang dapat ditampilkan.",
      });
    }

    return res.json({ reply });
  } catch (error) {
    console.error("xAI request failed:", error.message);
    return res.status(502).json({
      error: "Gagal menghubungi layanan Grok. Coba lagi nanti.",
    });
  }
});

if (require.main === module) {
  const port = Number(process.env.PORT || 3000);
  const host = process.env.HOST || "127.0.0.1";
  app.listen(port, host, () => {
    console.log(`TeleCare AI backend berjalan di port ${port}`);
  });
}

module.exports = app;
