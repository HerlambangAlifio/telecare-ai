
const path = require("node:path");
require("dotenv").config({
  path: path.join(__dirname, ".env"),
});

const express = require("express");

const app = express();
app.use(express.json({ limit: "32kb" }));

// ============================================
// 1. CEK STATUS BACKEND
// ============================================

app.get("/", (_req, res) => {
  res.json({
    status: "Backend TeleCare AI aktif",
  });
});

// ============================================
// 2. EDUKASI KESEHATAN MENGGUNAKAN GROK
//    Mempertahankan fitur lama tim
// ============================================

app.post("/chat", async (req, res) => {
  const {
    complaint,
    duration,
    frequency,
    detail = "",
  } = req.body ?? {};

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
    return res.status(400).json({
      error: "Data keluhan tidak valid.",
    });
  }

  if (!process.env.XAI_API_KEY) {
    return res.status(503).json({
      error: "XAI_API_KEY belum dikonfigurasi.",
    });
  }

  try {
    const response = await fetch(
      "https://api.x.ai/v1/responses",
      {
        method: "POST",
        headers: {
          Authorization:
            `Bearer ${process.env.XAI_API_KEY}`,
          "Content-Type": "application/json",
        },
        signal: AbortSignal.timeout(60000),
body: JSON.stringify({
  contents,
  generationConfig: {
    maxOutputTokens: 150,
  },
}),
      }
    );

    if (!response.ok) {
      console.error("Grok HTTP:", response.status);

      return res.status(502).json({
        error: "Grok tidak dapat memberikan jawaban.",
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
      return res.status(502).json({
        error: "Grok tidak mengembalikan jawaban.",
      });
    }

    return res.json({ reply });
  } catch (error) {
    console.error("Grok error:", error.message);

    return res.status(502).json({
      error: "Gagal menghubungi layanan Grok.",
    });
  }
});

// ============================================
// 3. CHATBOT GEMINI AI
//    Endpoint untuk chat_ai_page.dart
// ============================================

app.post("/chatbot", async (req, res) => {
  const { message, history = [] } = req.body ?? {};

  // Validasi pesan pengguna
  if (
    typeof message !== "string" ||
    !message.trim() ||
    message.length > 1000 ||
    !Array.isArray(history) ||
    history.length > 10 ||
    history.some(
      (item) =>
        !item ||
        !["user", "model"].includes(item.role) ||
        typeof item.text !== "string" ||
        !item.text.trim() ||
        item.text.length > 1000
    )
  ) {
    return res.status(400).json({
      error: "Pesan atau riwayat chat tidak valid.",
    });
  }

  // Pastikan API key Gemini tersedia
  if (!process.env.GEMINI_API_KEY) {
    return res.status(503).json({
      error: "GEMINI_API_KEY belum dikonfigurasi.",
    });
  }

  try {
    const model =
      process.env.GEMINI_MODEL ||
      "gemini-3.5-flash-lite";

      console.log("Model Gemini:", model);
console.log("Jumlah riwayat:", history.length);

    // Menyusun riwayat percakapan
    const contents = [
      ...history.map((item) => ({
        role: item.role,
        parts: [
          {
            text: item.text,
          },
        ],
      })),
      {
        role: "user",
        parts: [
          {
            text: message.trim(),
          },
        ],
      },
    ];

    // Mengirim pertanyaan ke Gemini
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${encodeURIComponent(model)}:generateContent`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": process.env.GEMINI_API_KEY,
        },
        signal: AbortSignal.timeout(60000),
        body: JSON.stringify({
          systemInstruction: {
            parts: [
              {
                text:
                  "Kamu adalah TeleCare AI, asisten virtual " +
                  "untuk edukasi kesehatan. " +
                  "Jawab menggunakan bahasa Indonesia " +
                  "yang ramah, sederhana, dan mudah dipahami. " +
                  "Berikan informasi kesehatan secara umum. " +
                  "Jangan memberikan diagnosis pasti, " +
                  "resep obat, atau dosis pengobatan. " +
                  "Jika informasi belum cukup, " +
                  "ajukan pertanyaan lanjutan. " +
                  "Jika pengguna mengalami gejala berat " +
                  "seperti sesak napas berat, nyeri dada, " +
                  "kejang, pingsan, atau penurunan kesadaran, " +
                  "sarankan segera mencari pertolongan " +
                  "medis darurat. " +
                  "Jelaskan bahwa jawaban AI " +
                  "bukan pengganti pemeriksaan dokter.",
              },
            ],
          },
          contents,
          generationConfig: {
            maxOutputTokens: 500,
          },
        }),
      }
    );

    // Menangani error dari Gemini
    if (!response.ok) {
      console.error(
        "Gemini HTTP error:",
        response.status
      );

      return res.status(502).json({
        error: "Layanan Gemini sedang tidak tersedia.",
      });
    }

    const result = await response.json();

    // Mengambil teks balasan Gemini
    const reply = (
      result.candidates?.[0]?.content?.parts ?? []
    )
      .map((part) => part.text ?? "")
      .join("\n")
      .trim();

    if (!reply) {
      return res.status(502).json({
        error: "Gemini tidak menghasilkan jawaban.",
      });
    }

    // Mengirim jawaban kembali ke Flutter
    return res.json({
      reply,
    });
 } catch (error) {
  console.error("========== GEMINI ERROR ==========");
  console.error("Nama:", error.name);
  console.error("Pesan:", error.message);
  console.error("Penyebab:", error.cause?.message);
  console.error("Kode:", error.cause?.code);
  console.error("==================================");

  return res.status(502).json({
    error: "Gagal menghubungi layanan AI.",
  });
}
});

// ============================================
// 4. CHAT PASIEN DAN DOKTER
//    Penyimpanan sementara tanpa database
// ============================================

const doctorMessages = [];
let nextMessageId = 1;

// Mengambil semua pesan
app.get("/doctor/messages", (_req, res) => {
  return res.json({
    messages: doctorMessages,
  });
});

// Mengirim pesan pasien atau dokter
app.post("/doctor/messages", (req, res) => {
  const { sender, text } = req.body ?? {};

  if (
    !["pasien", "dokter"].includes(sender) ||
    typeof text !== "string" ||
    !text.trim() ||
    text.length > 1000
  ) {
    return res.status(400).json({
      error: "Data pesan tidak valid.",
    });
  }

  // Membuat pesan baru
  const message = {
    id: nextMessageId++,
    sender,
    text: text.trim(),
    createdAt: new Date().toISOString(),
  };

  // Simpan pesan sementara
  doctorMessages.push(message);

  // Maksimal 100 pesan
  if (doctorMessages.length > 100) {
    doctorMessages.shift();
  }

  return res.status(201).json({
    message,
  });
});

// ============================================
// 5. JALANKAN SERVER
// ============================================

if (require.main === module) {
  const port = Number(process.env.PORT || 3000);
  const host = process.env.HOST || "127.0.0.1";

  app.listen(port, host, () => {
    console.log(
      `TeleCare AI backend berjalan di port ${port}`
    );
    console.log("Endpoint tersedia:");
    console.log("GET  /");
    console.log("POST /chat");
    console.log("POST /chatbot");
    console.log("GET  /doctor/messages");
    console.log("POST /doctor/messages");
  });
}

module.exports = app;
