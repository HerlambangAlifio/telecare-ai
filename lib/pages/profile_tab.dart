
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// =====================================
// DATA PROFIL
// =====================================

class ProfileInfo {
  final String name;
  final String phone;

  const ProfileInfo({
    required this.name,
    this.phone = '',
  });
}

// =====================================
// PENYIMPANAN SEMENTARA DI RAM
// =====================================

class ProfileMemory {
  static final ValueNotifier<ProfileInfo> pasien =
      ValueNotifier(
    const ProfileInfo(name: 'Pasien TeleCare'),
  );

  static final ValueNotifier<ProfileInfo> dokter =
      ValueNotifier(
    const ProfileInfo(name: 'Dokter TeleCare'),
  );

  static ValueNotifier<ProfileInfo> of(String role) {
    return role == 'dokter' ? dokter : pasien;
  }
}

// =====================================
// HALAMAN PROFIL
// =====================================

class ProfileTab extends StatelessWidget {
  final String role;
  final VoidCallback onLogout;

  const ProfileTab({
    super.key,
    required this.role,
    required this.onLogout,
  });

  bool get _isDoctor => role == 'dokter';

  Future<void> _editProfile(
    BuildContext context,
    ValueNotifier<ProfileInfo> notifier,
  ) async {
    final result = await showDialog<ProfileInfo>(
      context: context,
      builder: (_) => _EditProfileDialog(
        initialProfile: notifier.value,
      ),
    );

    if (result == null || !context.mounted) return;

    // Simpan perubahan ke memori Flutter.
    notifier.value = result;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil diperbarui!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tentang TeleCare AI'),
        content: const Text(
          'TeleCare AI adalah prototipe aplikasi '
          'telehealth berbasis AI.\n\n'
          'Aplikasi menyediakan Chat Gemini AI '
          'dan konsultasi pasien-dokter melalui pesan.\n\n'
          'Aplikasi dibuat untuk tugas kuliah, '
          'bukan layanan medis aktif.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    final color =
        danger ? const Color(0xFFE04A4A) : blue;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE3EAF4),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: danger ? color : navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
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

  Widget _infoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        children: [
          Icon(icon, color: blue, size: 22),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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
    final notifier = ProfileMemory.of(role);

    return ValueListenableBuilder<ProfileInfo>(
      valueListenable: notifier,
      builder: (context, profile, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(
            18, 22, 18, 30,
          ),
          children: [
            const Text(
              'Profil Saya',
              style: TextStyle(
                color: navy,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Kelola informasi akun TeleCare AI.',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 22),

            // KARTU PROFIL
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(23),
                border: Border.all(
                  color: const Color(0xFFE3EAF4),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 43,
                    backgroundColor:
                        const Color(0xFFEAF3FF),
                    child: Icon(
                      _isDoctor
                          ? Icons.medical_services_rounded
                          : Icons.person_rounded,
                      color: blue,
                      size: 43,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    profile.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Chip(
                    label: Text(
                      _isDoctor ? 'Dokter' : 'Pasien',
                    ),
                    backgroundColor:
                        const Color(0xFFE7F8F0),
                    side: BorderSide.none,
                  ),
                  const SizedBox(height: 15),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _editProfile(context, notifier),
                    icon: const Icon(
                      Icons.edit_outlined,
                    ),
                    label: const Text('Edit Profil'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            const Text(
              'Informasi Profil',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: const Color(0xFFE3EAF4),
                ),
              ),
              child: Column(
                children: [
                  _infoRow(
                    Icons.person_outline,
                    'Nama Lengkap',
                    profile.name,
                  ),
                  const Divider(height: 1),
                  _infoRow(
                    Icons.phone_outlined,
                    'Nomor Telepon',
                    profile.phone.isEmpty
                        ? 'Belum diisi'
                        : profile.phone,
                  ),
                  const Divider(height: 1),
                  _infoRow(
                    Icons.badge_outlined,
                    'Peran Akun',
                    _isDoctor ? 'Dokter' : 'Pasien',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            const Text(
              'Pengaturan Akun',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 13),

            _menuItem(
              icon: Icons.info_outline,
              title: 'Tentang Aplikasi',
              subtitle: 'Informasi TeleCare AI',
              onTap: () => _showAbout(context),
            ),

            const SizedBox(height: 12),

            _menuItem(
              icon: Icons.logout_rounded,
              title: 'Keluar dari Akun',
              subtitle: 'Kembali ke halaman login',
              danger: true,
              onTap: onLogout,
            ),

            const SizedBox(height: 22),
            const Text(
              'Perubahan profil hanya tersimpan '
              'sementara selama aplikasi berjalan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 11,
              ),
            ),
          ],
        );
      },
    );
  }
}

// =====================================
// DIALOG EDIT PROFIL
// =====================================

class _EditProfileDialog extends StatefulWidget {
  final ProfileInfo initialProfile;

  const _EditProfileDialog({
    required this.initialProfile,
  });

  @override
  State<_EditProfileDialog> createState() =>
      _EditProfileDialogState();
}

class _EditProfileDialogState
    extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.initialProfile.name,
    );

    _phoneController = TextEditingController(
      text: widget.initialProfile.phone,
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      ProfileInfo(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Profil',
        style: TextStyle(
          color: navy,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 350,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  maxLength: 60,
                  textCapitalization:
                      TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: Icon(
                      Icons.person_outline,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon',
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
