import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'doctor_chat_page.dart';

class DoctorSelectionPage extends StatelessWidget {
  const DoctorSelectionPage({super.key});

  static const Color background = Color(0xFFF6F9FF);
  static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color teal = Color(0xFF0E9C8B);

  void _startConsultation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DoctorChatPage(role: 'pasien'),
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: blue, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: navy,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Pilih Dokter',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 30),
          children: [
            const Text(
              'Konsultasi dengan Dokter',
              style: TextStyle(
                color: navy,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pilih dokter untuk mendapatkan layanan '
              'konsultasi kesehatan ibu dan kehamilan.',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 23),
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD7EAFF), Color(0xFFEEF8FF)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.pregnant_woman_rounded, color: blue, size: 35),
                  SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Poli Kandungan',
                          style: TextStyle(
                            color: navy,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Layanan kesehatan ibu dan kehamilan',
                          style: TextStyle(
                            color: Color(0xFF4E6380),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Dokter Konsultasi',
              style: TextStyle(
                color: navy,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(23),
                border: Border.all(color: const Color(0xFFE2EAF4)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x090E4C92),
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: const Icon(
                          Icons.medical_services_rounded,
                          color: blue,
                          size: 38,
                        ),
                      ),
                      const SizedBox(width: 13),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'dr. Salsabila Putri, Sp.OG',
                              style: TextStyle(
                                color: navy,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Spesialis Obstetri dan Ginekologi',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F8F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Dokter Simulasi',
                      style: TextStyle(
                        color: teal,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  const Divider(),
                  const SizedBox(height: 13),
                  _infoItem(
                    icon: Icons.favorite_outline_rounded,
                    title: 'Bidang Konsultasi',
                    subtitle: 'Kesehatan ibu, informasi kehamilan, '
                        'dan kesehatan reproduksi.',
                  ),
                  const SizedBox(height: 18),
                  _infoItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Metode Konsultasi',
                    subtitle: 'Percakapan melalui fitur Chat Dokter.',
                  ),
                  const SizedBox(height: 18),
                  _infoItem(
                    icon: Icons.info_outline_rounded,
                    title: 'Informasi Layanan',
                    subtitle: 'Profil dan konsultasi ini digunakan untuk '
                        'demonstrasi aplikasi TeleCare AI.',
                  ),
                  const SizedBox(height: 23),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () => _startConsultation(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(Icons.chat_rounded, size: 20),
                      label: const Text(
                        'Mulai Konsultasi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.verified_user_outlined, color: blue),
                  SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      'Layanan konsultasi ini merupakan simulasi untuk '
                      'tugas kuliah. Gunakan data fiktif dan jangan '
                      'memasukkan informasi medis pribadi.',
                      style: TextStyle(
                        color: navy,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
