import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';
import 'doctor_chat_page.dart';

class ResultPage extends StatelessWidget {
  final String complaint;
  final String duration;
  final String frequency;
  final String detail;
  final String aiResponse;

  const ResultPage({
    super.key,
    required this.complaint,
    required this.duration,
    required this.frequency,
    required this.detail,
    required this.aiResponse,
  });

  @override
  Widget build(BuildContext context) {
    final lower = '$complaint $detail'.toLowerCase();
    final danger = [
      'sesak napas',
      'sesak berat',
      'nyeri dada',
      'pingsan',
      'tidak sadar',
      'kejang',
      'batuk darah',
    ].any(lower.contains);
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Asisten AI')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const StepBanner(step: 2),
          const SizedBox(height: 22),
          panel(
            color: const Color(0xFFE5F8F3),
            child: const Row(
              children: [
                Icon(
                  Icons.smart_toy_outlined,
                  color: Color(0xFF008B75),
                  size: 43,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Jawaban edukasi dari Grok. Bukan diagnosis medis atau pengganti tenaga kesehatan.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          section(
            'Ringkasan Keluhan',
            Icons.assignment_outlined,
            'Keluhan: $complaint\nDurasi: $duration\nFrekuensi: $frequency${detail.isEmpty ? '' : '\nKeterangan: $detail'}',
          ),
          const SizedBox(height: 14),
          section('Jawaban Grok', Icons.lightbulb_outline, aiResponse),
          const SizedBox(height: 14),
          section(
            'Saran dan Tanda Bahaya',
            Icons.health_and_safety_outlined,
            danger
                ? 'TANDA BAHAYA TERDETEKSI. Segera hubungi layanan darurat setempat atau datang ke IGD. Jangan menunggu chat simulasi.'
                : 'Istirahat yang cukup dan pantau kondisi. Segera cari pertolongan medis bila mengalami sesak napas berat, nyeri dada, penurunan kesadaran, atau kondisi memburuk.',
          ),
          const SizedBox(height: 22),
          primaryButton(
            'Lanjutkan ke Konsultasi Dokter  →',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DoctorChatPage()),
            ),
          ),
        ],
      ),
    );
  }
}
