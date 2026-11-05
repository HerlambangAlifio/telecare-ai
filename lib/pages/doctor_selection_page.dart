
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'consultation_payment_page.dart';

class DoctorSelectionPage extends StatelessWidget {
  const DoctorSelectionPage({super.key});

  static const Color background = Color(0xFFF6F9FF);
  static const Color lightBlue = Color(0xFFEAF3FF);

  void _openPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ConsultationPaymentPage(),
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: navy,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        title: const Text(
          'Pilih Dokter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        foregroundColor: navy,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              'Konsultasi dengan Dokter',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Pilih dokter untuk berkonsultasi '
              'mengenai kesehatan ibu dan kehamilan.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blueGrey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 22),

            // INFORMASI POLI
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFD6E9FF),
                    Color(0xFFF1F8FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.pregnant_woman_rounded,
                    color: blue,
                    size: 38,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
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
                            color: Colors.blueGrey,
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

            const SizedBox(height: 13),

            // KARTU DOKTER
            Container(
              padding: const EdgeInsets.all(19),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(23),
                border: Border.all(
                  color: const Color(0xFFE2EAF4),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius:
                              BorderRadius.circular(18),
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
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'dr. Salsabila Putri, Sp.OG',
                              style: TextStyle(
                                color: navy,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Spesialis Obstetri dan Ginekologi',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

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
                        color: Color(0xFF14846C),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),

                  const SizedBox(height: 17),
                  const Divider(),
                  const SizedBox(height: 12),

                  _infoItem(
                    icon: Icons.favorite_outline,
                    title: 'Bidang Konsultasi',
                    description:
                        'Kesehatan ibu, kehamilan, '
                        'dan kesehatan reproduksi.',
                  ),

                  _infoItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'Metode Konsultasi',
                    description:
                        'Konsultasi melalui pesan '
                        'di aplikasi TeleCare AI.',
                  ),

                  _infoItem(
                    icon: Icons.info_outline,
                    title: 'Jenis Layanan',
                    description:
                        'Simulasi konsultasi untuk '
                        'demonstrasi tugas kuliah.',
                  ),

                  const Divider(),
                  const SizedBox(height: 12),

                  // BIAYA KONSULTASI
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Biaya Konsultasi (Simulasi)',
                            style: TextStyle(
                              color: navy,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          'Rp35.000',
                          style: TextStyle(
                            color: blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 17),

                  // TOMBOL PEMBAYARAN
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () => _openPayment(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(Icons.payment_rounded),
                      label: const Text(
                        'Lanjut ke Pembayaran',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: blue,
                  ),
                  SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      'Profil dokter dan biaya '
                      'hanya digunakan untuk simulasi. '
                      'Tidak ada layanan medis atau '
                      'penagihan sungguhan.',
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
