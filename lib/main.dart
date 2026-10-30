import 'package:flutter/material.dart';

void main() => runApp(const TeleCareApp());

const blue = Color(0xFF0878D7);
const navy = Color(0xFF122B51);
const pale = Color(0xFFF4F9FF);

class TeleCareApp extends StatelessWidget {
  const TeleCareApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'TeleCare AI', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFF9FCFF),
      colorScheme: ColorScheme.fromSeed(seedColor: blue),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: navy, centerTitle: true),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFD8E5F3))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFD8E5F3))))),
    home: const HomePage(),
  );
}

Widget primaryButton(String label, VoidCallback onTap) => SizedBox(width: double.infinity, height: 52,
  child: FilledButton(onPressed: onTap, style: FilledButton.styleFrom(backgroundColor: blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
  child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))));

Widget panel({required Widget child, Color color = Colors.white}) => Container(
  padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFE0EAF5))), child: child);

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('TeleCare AI', style: TextStyle(fontWeight: FontWeight.bold, color: blue)), centerTitle: false,
      actions: const [Padding(padding: EdgeInsets.only(right: 20), child: Icon(Icons.notifications_none_outlined))]),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: const LinearGradient(colors: [Color(0xFFD4ECFF), Color(0xFFEDF8FF)])),
        child: const Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Konsultasi Kesehatan Lebih Mudah dari Mana Saja', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: navy)), SizedBox(height: 10), Text('Dapatkan edukasi kesehatan awal dan simulasi konsultasi jarak jauh.')])), SizedBox(width: 12), Icon(Icons.medical_services_rounded, color: blue, size: 65)])),
      const SizedBox(height: 22),
      menuTile(context, Icons.smart_toy_outlined, 'Konsultasi dengan Asisten AI', 'Ceritakan keluhan dan dapatkan edukasi awal', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComplaintPage()))),
      menuTile(context, Icons.medical_services_outlined, 'Konsultasi Dokter', 'Simulasi percakapan dengan dokter', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorChatPage()))),
      menuTile(context, Icons.history, 'Tentang Layanan', 'Informasi penggunaan aplikasi', () => showDialog(context: context, builder: (ctx) => AlertDialog(title: const Text('Tentang TeleCare AI'), content: const Text('Prototipe tugas kuliah untuk edukasi kesehatan dan simulasi konsultasi jarak jauh. Bukan layanan medis aktif.'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup'))]))),
      const SizedBox(height: 16), panel(color: const Color(0xFFE7F3FF), child: const Row(children: [Icon(Icons.verified_user_outlined, color: blue), SizedBox(width: 12), Expanded(child: Text('Penting: Aplikasi ini hanya memberikan edukasi, bukan diagnosis atau pengganti tenaga medis.'))])),
    ]),
    bottomNavigationBar:  NavigationBar(selectedIndex: 0, destinations: [NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Beranda'), NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Konsultasi'), NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil')]),
  );
}

Widget menuTile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback action) => Padding(padding: const EdgeInsets.only(bottom: 13), child: InkWell(onTap: action, borderRadius: BorderRadius.circular(17), child: panel(child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFE5F2FF), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: blue, size: 28)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: navy)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: Colors.blueGrey, fontSize: 12))])), const Icon(Icons.chevron_right, color: blue)]))));

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});
  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}
class _ComplaintPageState extends State<ComplaintPage> {
  final complaint = TextEditingController();
  final detail = TextEditingController();
  String duration = '1–3 hari';
  String frequency = 'Kadang-kadang';
  @override
  void dispose() { complaint.dispose(); detail.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Konsultasi dengan AI')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const StepBanner(step: 1), const SizedBox(height: 24), const Icon(Icons.chat_bubble_rounded, color: blue, size: 48), const SizedBox(height: 12),
      const Text('Ceritakan Keluhan Anda', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: navy)),
      const SizedBox(height: 8), const Text('Jelaskan keluhan agar sistem dapat menampilkan edukasi kesehatan awal.', textAlign: TextAlign.center),
      const SizedBox(height: 28), const Text('Apa keluhan utama Anda?', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8),
      TextField(controller: complaint, decoration: const InputDecoration(hintText: 'Contoh: batuk, demam, sakit kepala')),
      const SizedBox(height: 18), const Text('Kapan keluhan mulai dirasakan?', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8),
      DropdownButtonFormField<String>(initialValue: duration, items: ['Hari ini', '1–3 hari', '4–7 hari', 'Lebih dari 7 hari'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => duration = v!)),
      const SizedBox(height: 18), const Text('Seberapa sering keluhan terjadi?', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8),
      DropdownButtonFormField<String>(initialValue: frequency, items: ['Jarang', 'Kadang-kadang', 'Sering', 'Terus-menerus'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => frequency = v!)),
      const SizedBox(height: 18), const Text('Deskripsi tambahan (opsional)', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8),
      TextField(controller: detail, maxLines: 4, maxLength: 200, decoration: const InputDecoration(hintText: 'Ceritakan lebih detail keluhan Anda...')),
      const SizedBox(height: 12), primaryButton('Lanjutkan  →', () {
        if (complaint.text.trim().isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi keluhan utama terlebih dahulu.'))); return; }
        Navigator.push(context, MaterialPageRoute(builder: (_) => ResultPage(complaint: complaint.text.trim(), duration: duration, frequency: frequency, detail: detail.text.trim())));
      }),
    ]));
}

class StepBanner extends StatelessWidget {
  final int step;

  const StepBanner({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    final labels = [
      'Isi Keluhan',
      'Hasil AI',
      'Konsultasi',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(3, (i) {
        return Expanded(
          child: Column(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: i + 1 <= step
                    ? blue
                    : const Color(0xFFE5ECF4),
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: i + 1 <= step
                        ? Colors.white
                        : Colors.blueGrey,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11,
                  color: i + 1 == step
                      ? blue
                      : Colors.blueGrey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ResultPage extends StatelessWidget {
  final String complaint, duration, frequency, detail;
  const ResultPage({super.key, required this.complaint, required this.duration, required this.frequency, required this.detail});
  @override
  Widget build(BuildContext context) {
    final lower = '$complaint $detail'.toLowerCase();
    final danger = ['sesak napas', 'sesak berat', 'nyeri dada', 'pingsan', 'tidak sadar', 'kejang', 'batuk darah'].any(lower.contains);
    String education = 'Keluhan dapat memiliki berbagai penyebab. Catat perkembangan gejala, cukup istirahat, dan konsultasikan dengan tenaga kesehatan bila menetap atau memburuk.';
    if (lower.contains('batuk')) { education = 'Batuk dapat berhubungan dengan iritasi atau infeksi saluran pernapasan. Cukupi cairan dan istirahat. Jika berlangsung lama atau disertai tanda bahaya, periksakan diri.'; }
    else if (lower.contains('demam')) { education = 'Demam merupakan peningkatan suhu tubuh yang dapat memiliki beragam penyebab. Pantau suhu, cukup minum, dan cari bantuan medis jika berat atau memburuk.'; }
    else if (lower.contains('kepala') || lower.contains('pusing')) { education = 'Sakit kepala atau pusing memiliki banyak penyebab. Beristirahat dan mencukupi cairan dapat membantu, tetapi gejala mendadak berat perlu pemeriksaan segera.'; }
    return Scaffold(appBar: AppBar(title: const Text('Hasil Asisten AI')),
      body: ListView(padding: const EdgeInsets.all(20), children: [const StepBanner(step: 2), const SizedBox(height: 22),
        panel(color: const Color(0xFFE5F8F3), child: const Row(children: [Icon(Icons.smart_toy_outlined, color: Color(0xFF008B75), size: 43), SizedBox(width: 14), Expanded(child: Text('Informasi awal berdasarkan aturan edukasi kesehatan. Bukan diagnosis medis.'))])),
        const SizedBox(height: 15), section('Ringkasan Keluhan', Icons.assignment_outlined, 'Keluhan: $complaint\nDurasi: $duration\nFrekuensi: $frequency${detail.isEmpty ? '' : '\nKeterangan: $detail'}'),
        const SizedBox(height: 14), section('Informasi Kesehatan', Icons.lightbulb_outline, education),
        const SizedBox(height: 14), section('Saran dan Tanda Bahaya', Icons.health_and_safety_outlined,
          danger ? 'TANDA BAHAYA TERDETEKSI. Segera hubungi layanan darurat setempat atau datang ke IGD. Jangan menunggu chat simulasi.' : 'Istirahat yang cukup dan pantau kondisi. Segera cari pertolongan medis bila mengalami sesak napas berat, nyeri dada, penurunan kesadaran, atau kondisi memburuk.'),
        const SizedBox(height: 22), primaryButton('Lanjutkan ke Konsultasi Dokter  →', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorChatPage()))),
      ]));
  }
}
Widget section(String title, IconData icon, String body) => panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, color: blue), const SizedBox(width: 9), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: navy)))]), const SizedBox(height: 10), Text(body, style: const TextStyle(height: 1.5))]));

class DoctorChatPage extends StatefulWidget {
  const DoctorChatPage({super.key});
  @override
  State<DoctorChatPage> createState() => _DoctorChatPageState();
}
class _DoctorChatPageState extends State<DoctorChatPage> {
  final controller = TextEditingController();
  final messages = <({String text, bool mine})>[
    (text: 'Halo Dok, saya ingin berkonsultasi mengenai keluhan saya.', mine: true),
    (text: 'Halo! Ini adalah simulasi chat dokter untuk demonstrasi aplikasi TeleCare AI. Tidak ada dokter sungguhan yang menerima pesan ini.', mine: false),
  ];
  void send() {
    final message = controller.text.trim(); if (message.isEmpty) return;
    setState(() { messages.add((text: message, mine: true)); messages.add((text: 'Terima kasih. Ini balasan otomatis simulasi, bukan nasihat dokter. Jika keluhan berat atau darurat, segera hubungi fasilitas kesehatan.', mine: false)); controller.clear(); });
  }
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Column(children: [Text('Konsultasi Dokter'), Text('Simulasi • bukan dokter aktif', style: TextStyle(fontSize: 11, color: Colors.teal))])),
    body: Column(children: [Padding(padding: const EdgeInsets.all(14), child: panel(child: const Row(children: [CircleAvatar(backgroundColor: Color(0xFFE4F2FF), child: Icon(Icons.person, color: blue)), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Dokter Virtual (Simulasi)', style: TextStyle(fontWeight: FontWeight.bold)), Text('Percakapan demonstrasi • offline', style: TextStyle(fontSize: 12, color: Colors.blueGrey))]))]))),
      Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), itemCount: messages.length, itemBuilder: (context, index) { final m = messages[index]; return Align(alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .82), decoration: BoxDecoration(color: m.mine ? blue : const Color(0xFFEAF0F6), borderRadius: BorderRadius.circular(16)), child: Text(m.text, style: TextStyle(color: m.mine ? Colors.white : navy, height: 1.4)))); })),
      SafeArea(child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [Expanded(child: TextField(controller: controller, onSubmitted: (_) => send(), decoration: const InputDecoration(hintText: 'Ketik pesan Anda...', contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)))), const SizedBox(width: 8), IconButton.filled(onPressed: send, icon: const Icon(Icons.send), style: IconButton.styleFrom(backgroundColor: blue))]))),
    ]));
}
