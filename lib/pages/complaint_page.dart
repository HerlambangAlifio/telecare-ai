import 'package:flutter/material.dart';

import '../services/telecare_api.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import 'result_page.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final complaint = TextEditingController();
  final detail = TextEditingController();
  final api = TeleCareApi();
  String duration = '1–3 hari';
  String frequency = 'Kadang-kadang';
  bool isProcessing = false;

  @override
  void dispose() {
    complaint.dispose();
    detail.dispose();
    api.close();
    super.dispose();
  }

  Future<void> submitComplaint() async {
    if (isProcessing) return;
    if (complaint.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi keluhan utama terlebih dahulu.')),
      );
      return;
    }

    setState(() => isProcessing = true);
    try {
      final consent = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kirim keluhan ke Grok?'),
          content: const Text(
            'Keluhan dan keterangan yang Anda masukkan akan dikirim ke layanan xAI melalui backend aplikasi untuk menghasilkan edukasi kesehatan. '
            'Jangan sertakan nama atau informasi pribadi. Ini bukan diagnosis medis.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Setuju dan lanjut'),
            ),
          ],
        ),
      );
      if (!mounted || consent != true) return;

      final answer = await api.getEducation(
        complaint: complaint.text.trim(),
        duration: duration,
        frequency: frequency,
        detail: detail.text.trim(),
      );
      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            complaint: complaint.text.trim(),
            duration: duration,
            frequency: frequency,
            detail: detail.text.trim(),
            aiResponse: answer,
          ),
        ),
      );
    } on TeleCareApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Konsultasi dengan AI')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const StepBanner(step: 1),
        const SizedBox(height: 24),
        const Icon(Icons.chat_bubble_rounded, color: blue, size: 48),
        const SizedBox(height: 12),
        const Text(
          'Ceritakan Keluhan Anda',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Jelaskan keluhan agar sistem dapat menampilkan edukasi kesehatan awal.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Keluhan akan dikirim ke xAI untuk dibuatkan edukasi AI. Jangan masukkan nama atau informasi pribadi.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.blueGrey),
        ),
        const SizedBox(height: 28),
        const Text(
          'Apa keluhan utama Anda?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: complaint,
          decoration: const InputDecoration(
            hintText: 'Contoh: batuk, demam, sakit kepala',
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Kapan keluhan mulai dirasakan?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: duration,
          items: [
            'Hari ini',
            '1–3 hari',
            '4–7 hari',
            'Lebih dari 7 hari',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => duration = v!),
        ),
        const SizedBox(height: 18),
        const Text(
          'Seberapa sering keluhan terjadi?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: frequency,
          items: [
            'Jarang',
            'Kadang-kadang',
            'Sering',
            'Terus-menerus',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => frequency = v!),
        ),
        const SizedBox(height: 18),
        const Text(
          'Deskripsi tambahan (opsional)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: detail,
          maxLines: 4,
          maxLength: 200,
          decoration: const InputDecoration(
            hintText: 'Ceritakan lebih detail keluhan Anda...',
          ),
        ),
        const SizedBox(height: 12),
        primaryButton(
          isProcessing ? 'Menghubungi Grok...' : 'Lanjutkan  →',
          isProcessing ? () {} : submitComplaint,
        ),
        if (isProcessing) ...[
          const SizedBox(height: 12),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    ),
  );
}
