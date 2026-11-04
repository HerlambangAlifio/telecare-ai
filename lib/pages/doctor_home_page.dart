
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'doctor_chat_page.dart';
import 'profile_tab.dart';

class DoctorHomePage extends StatefulWidget {
  final VoidCallback onLogout;

  const DoctorHomePage({
    super.key,
    required this.onLogout,
  });

  @override
  State<DoctorHomePage> createState() =>
      _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  int _selectedIndex = 0;

  static const Color background = Color(0xFFF6F9FF);
  static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color teal = Color(0xFF0E9C8B);

  // =====================================
  // BUKA CHAT PASIEN
  // =====================================

  void _openPatientChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DoctorChatPage(
          role: 'dokter',
        ),
      ),
    );
  }

  // =====================================
  // KONFIRMASI LOGOUT
  // =====================================

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari Akun'),
        content: const Text(
          'Apakah Anda yakin ingin keluar '
          'dari TeleCare AI?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (shouldLogout == true) {
      widget.onLogout();
    }
  }

  // =====================================
  // INFORMASI APLIKASI
  // =====================================

  void _showAbout() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tentang TeleCare AI'),
        content: const Text(
          'TeleCare AI merupakan prototipe '
          'aplikasi telehealth berbasis AI.\n\n'
          'Dokter dapat berkomunikasi dengan '
          'pasien melalui fitur chat konsultasi.\n\n'
          'Aplikasi ini dibuat untuk tugas '
          'kuliah dan bukan layanan medis aktif.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // =====================================
  // HALAMAN UTAMA
  // =====================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 18,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF168CF2),
                    Color(0xFF16C9AD),
                  ],
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.monitor_heart_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TeleCare AI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                  Text(
                    'Dashboard Dokter',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(
              Icons.logout_rounded,
              color: navy,
            ),
            onPressed: _confirmLogout,
          ),
          const SizedBox(width: 8),
        ],
      ),


body: switch (_selectedIndex) {
  0 => _buildDashboard(),
  1 => _buildConsultation(),
  _ => ProfileTab(
      role: 'dokter',
      onLogout: () {
        _confirmLogout();
      },
    ),
},


      bottomNavigationBar: NavigationBar(
        height: 72,
        elevation: 0,
        backgroundColor: Colors.white,
        indicatorColor: lightBlue,
        selectedIndex: _selectedIndex,
        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: blue,
            ),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(
              Icons.chat_bubble_rounded,
              color: blue,
            ),
            label: 'Konsultasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: blue,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // =====================================
  // DASHBOARD DOKTER
  // =====================================

  Widget _buildDashboard() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
      children: [
        // SAPAAN DOKTER
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medical_services_rounded,
                color: blue,
                size: 27,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, Dr Ammar!',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Selamat datang kembali.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F7F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Dokter',
                style: TextStyle(
                  color: Color(0xFF14846C),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // BANNER UTAMA
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFD5E9FF),
                Color(0xFFF0F8FF),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dampingi Pasien\nLebih Mudah',
                      style: TextStyle(
                        color: navy,
                        fontSize: 21,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Berikan tanggapan kepada '
                      'pasien melalui layanan '
                      'chat konsultasi TeleCare AI.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4E6380),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _openPatientChat,
                      style: FilledButton.styleFrom(
                        backgroundColor: blue,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(
                        Icons.chat_rounded,
                        size: 18,
                      ),
                      label: const Text(
                        'Buka Chat Pasien',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.medical_services_outlined,
                color: blue,
                size: 68,
              ),
            ],
          ),
        ),

        const SizedBox(height: 27),

        const Text(
          'Layanan Dokter',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Kelola komunikasi dengan pasien.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.blueGrey,
          ),
        ),

        const SizedBox(height: 15),

        _menuCard(
          icon: Icons.forum_rounded,
          title: 'Chat Pasien',
          subtitle:
              'Buka percakapan konsultasi '
              'dan balas pesan pasien.',
          color: blue,
          onTap: _openPatientChat,
        ),

        const SizedBox(height: 13),

        _menuCard(
          icon: Icons.info_outline_rounded,
          title: 'Informasi Layanan',
          subtitle:
              'Pelajari penggunaan TeleCare AI '
              'untuk akun dokter.',
          color: teal,
          onTap: _showAbout,
        ),

        const SizedBox(height: 27),

        const Text(
          'Panduan Konsultasi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),

        const SizedBox(height: 14),

        _stepCard(
          '01',
          'Buka Chat Pasien',
          'Masuk ke halaman konsultasi pasien.',
        ),

        const SizedBox(height: 10),

        _stepCard(
          '02',
          'Baca Pesan',
          'Periksa pesan yang dikirim pasien.',
        ),

        const SizedBox(height: 10),

        _stepCard(
          '03',
          'Berikan Tanggapan',
          'Balas pesan melalui kolom chat.',
        ),

        const SizedBox(height: 22),

        _informationNotice(),
      ],
    );
  }

  // =====================================
  // TAB KONSULTASI
  // =====================================

  Widget _buildConsultation() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
      children: [
        const Text(
          'Konsultasi Pasien',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Gunakan layanan chat untuk '
          'berkomunikasi dengan pasien.',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: Colors.blueGrey,
          ),
        ),

        const SizedBox(height: 24),

        _menuCard(
          icon: Icons.chat_bubble_rounded,
          title: 'Pesan Pasien',
          subtitle:
              'Lihat dan balas pesan '
              'konsultasi pasien.',
          color: blue,
          onTap: _openPatientChat,
        ),

        const SizedBox(height: 24),

        _informationNotice(),
      ],
    );
  }


  // =====================================
  // KOMPONEN MENU
  // =====================================

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: const Color(0xFFE2EAF4),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 27,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.blueGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================
  // KOMPONEN LANGKAH
  // =====================================

  Widget _stepCard(
    String number,
    String title,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE4EBF5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: blue,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // INFORMASI PENTING
  // =====================================

  Widget _informationNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: blue,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Aplikasi ini merupakan simulasi '
              'konsultasi kesehatan. Gunakan data '
              'fiktif saat demonstrasi dan jangan '
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
    );
  }
}
