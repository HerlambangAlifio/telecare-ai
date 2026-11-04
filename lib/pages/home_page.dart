import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'chat_ai_page.dart';
import 'doctor_selection_page.dart';
import 'profile_tab.dart';
class HomePage extends StatefulWidget {
  final VoidCallback onLogout;
  const HomePage({
    super.key,
    required this.onLogout,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const Color background = Color(0xFFF6F9FF);
  static const Color lightBlue = Color(0xFFEAF3FF);
  // Membuka Chat Gemini AI
  void _openChatAI() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChatAiPage(),
      ),
    );
  }
  // Membuka halaman Pilih Dokter, kemudian masuk ke Chat Dokter.
  void _openDoctorChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DoctorSelectionPage(),
      ),
    );
  }
  // Konfirmasi logout
  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari Akun'),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari TeleCare AI?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
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
                      color: navy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Layanan Kesehatan Jarak Jauh',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
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
            tooltip: 'Keluar dari Akun',
            onPressed: _confirmLogout,
            icon: const Icon(
              Icons.logout_rounded,
              color: navy,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Menu Profil sekarang menggunakan ProfileTab.
      body: switch (_selectedIndex) {
        0 => _buildHome(),
        1 => _buildConsultation(),
        _ => ProfileTab(
            role: 'pasien',
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
  // BERANDA PASIEN
  // =====================================
  Widget _buildHome() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: lightBlue,
              child: Icon(
                Icons.person_rounded,
                color: blue,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, Ammar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Semoga sehat selalu.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
            _roleBadge(),
          ],
        ),
        const SizedBox(height: 24),
        // Banner kesehatan ibu
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFD6E9FF),
                Color(0xFFF1F8FF),
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
                      'Kesehatan Ibu\nLebih Dekat',
                      style: TextStyle(
                        color: navy,
                        fontSize: 21,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Cari informasi awal seputar '
                      'kehamilan dan kesehatan ibu '
                      'bersama TeleCare AI.',
                      style: TextStyle(
                        color: Color(0xFF4E6380),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 15),
                    FilledButton.icon(
                      onPressed: _openChatAI,
                      style: FilledButton.styleFrom(
                        backgroundColor: blue,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(
                        Icons.auto_awesome,
                        size: 17,
                      ),
                      label: const Text('Tanya AI'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 82,
                height: 104,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.55,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.pregnant_woman_rounded,
                  color: blue,
                  size: 64,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _sectionHeader(
          'Layanan Kami',
          'Pilih layanan yang Anda butuhkan',
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _serviceCard(
                icon: Icons.smart_toy_rounded,
                title: 'Chat AI',
                subtitle:
                    'Tanya Gemini AI tentang kesehatan.',
                color: blue,
                onTap: _openChatAI,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _serviceCard(
                icon: Icons.medical_services_outlined,
                title: 'Chat Dokter',
                subtitle:
                    'Konsultasi lewat pesan (demo).',
                color: const Color(0xFF0E9C8B),
                onTap: _openDoctorChat,
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        _sectionHeader(
          'Cara Menggunakan',
          'Tiga langkah sederhana',
        ),
        const SizedBox(height: 13),
        _stepCard(
          '01',
          'Pilih layanan',
          'Gunakan Chat AI atau Chat Dokter.',
        ),
        const SizedBox(height: 9),
        _stepCard(
          '02',
          'Tulis pertanyaan',
          'Jelaskan informasi yang ingin ditanyakan.',
        ),
        const SizedBox(height: 9),
        _stepCard(
          '03',
          'Baca tanggapan',
          'Gunakan jawaban sebagai informasi awal.',
        ),
        const SizedBox(height: 22),
        _noticeCard(),
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
          'Mulai Konsultasi',
          style: TextStyle(
            color: navy,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pilih cara konsultasi yang sesuai '
          'dengan kebutuhan Anda.',
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 24),
        _consultationCard(
          icon: Icons.smart_toy_rounded,
          title: 'Chat AI Gemini',
          description:
              'Tanyakan informasi seputar '
              'kehamilan dan kesehatan ibu '
              'kepada asisten AI.',
          badge: 'AI',
          color: blue,
          onTap: _openChatAI,
        ),
        const SizedBox(height: 14),
        _consultationCard(
          icon: Icons.medical_services_rounded,
          title: 'Konsultasi Dokter',
          description:
              'Kirim dan terima pesan melalui '
              'simulasi konsultasi pasien dan dokter.',
          badge: 'Demo',
          color: const Color(0xFF0E9C8B),
          onTap: _openDoctorChat,
        ),
        const SizedBox(height: 24),
        _noticeCard(),
      ],
    );
  }
  // =====================================
  // KOMPONEN TAMPILAN
  // =====================================
  Widget _roleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F8F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Pasien',
        style: TextStyle(
          color: Color(0xFF14846C),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
  Widget _sectionHeader(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.blueGrey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  Widget _serviceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 180,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE3EAF4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 25,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _consultationCard({
    required IconData icon,
    required String title,
    required String description,
    required String badge,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE2EAF4),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      badge,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      title,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
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
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: blue,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
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
  Widget _noticeCard() {
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
            size: 23,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Informasi dari TeleCare AI bersifat '
              'edukatif dan bukan diagnosis medis. '
              'Jika mengalami keluhan serius, '
              'segera hubungi tenaga kesehatan.',
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
