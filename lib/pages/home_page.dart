import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import 'complaint_page.dart';
import 'doctor_chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        _selectedIndex == 0 ? 'TeleCare AI' : 'Konsultasi',
        style: const TextStyle(fontWeight: FontWeight.bold, color: blue),
      ),
      centerTitle: false,
      actions: _selectedIndex == 0
          ? const [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.notifications_none_outlined),
              ),
            ]
          : null,
    ),
    body: _selectedIndex == 0
        ? _buildHomeContent(context)
        : _buildConsultationContent(context),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: 'Beranda',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Konsultasi',
        ),
      ],
    ),
  );

  Widget _buildHomeContent(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFFD4ECFF), Color(0xFFEDF8FF)],
          ),
        ),
        child: const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Konsultasi Kesehatan Lebih Mudah dari Mana Saja',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Dapatkan edukasi kesehatan awal dan simulasi konsultasi jarak jauh.',
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.medical_services_rounded, color: blue, size: 65),
          ],
        ),
      ),
      const SizedBox(height: 22),
      menuTile(
        context,
        Icons.smart_toy_outlined,
        'Konsultasi dengan Asisten AI',
        'Ceritakan keluhan dan dapatkan edukasi awal',
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ComplaintPage()),
        ),
      ),
      menuTile(
        context,
        Icons.medical_services_outlined,
        'Konsultasi Dokter',
        'Simulasi percakapan dengan dokter',
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DoctorChatPage()),
        ),
      ),
      menuTile(
        context,
        Icons.history,
        'Tentang Layanan',
        'Informasi penggunaan aplikasi',
        () => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Tentang TeleCare AI'),
            content: const Text(
              'Prototipe tugas kuliah untuk edukasi kesehatan dan simulasi konsultasi jarak jauh. Bukan layanan medis aktif.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      panel(
        color: const Color(0xFFE7F3FF),
        child: const Row(
          children: [
            Icon(Icons.verified_user_outlined, color: blue),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Penting: Aplikasi ini hanya memberikan edukasi, bukan diagnosis atau pengganti tenaga medis.',
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildConsultationContent(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text(
        'Pilih jenis konsultasi',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: navy,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Pilih layanan yang ingin Anda gunakan.',
        style: TextStyle(color: Colors.blueGrey),
      ),
      const SizedBox(height: 22),
      menuTile(
        context,
        Icons.smart_toy_outlined,
        'Konsultasi dengan Asisten AI',
        'Ceritakan keluhan dan dapatkan edukasi awal',
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ComplaintPage()),
        ),
      ),
      menuTile(
        context,
        Icons.medical_services_outlined,
        'Konsultasi Dokter',
        'Simulasi percakapan dengan dokter',
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DoctorChatPage()),
        ),
      ),
      const SizedBox(height: 8),
      panel(
        color: const Color(0xFFE7F3FF),
        child: const Row(
          children: [
            Icon(Icons.verified_user_outlined, color: blue),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Layanan ini hanya untuk edukasi dan simulasi, bukan pengganti tenaga medis.',
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
