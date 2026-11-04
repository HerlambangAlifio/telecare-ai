
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<String> onLogin;

  const LoginPage({
    super.key,
    required this.onLogin,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = 'pasien';
  bool _obscurePassword = true;

  static const Color _background = Color(0xFFF6F9FF);
  static const Color _lightBlue = Color(0xFFEAF3FF);

  bool get _isDoctor => _selectedRole == 'dokter';

  // ==========================================
  // MEMILIH ROLE
  // ==========================================

  void _selectRole(String role) {
    if (_selectedRole == role) return;

    setState(() {
      _selectedRole = role;
      _usernameController.clear();
      _passwordController.clear();
    });

    _formKey.currentState?.reset();
  }

  // ==========================================
  // PROSES LOGIN
  // ==========================================

  void _submitLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username =
        _usernameController.text.trim().toLowerCase();

    final password = _passwordController.text;

    final correctUsername =
        _isDoctor ? 'dokter' : 'pasien';

    final correctPassword =
        _isDoctor ? 'dokter123' : 'pasien123';

    if (username == correctUsername &&
        password == correctPassword) {
      widget.onLogin(_selectedRole);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Username atau password tidak sesuai '
          'dengan akun yang dipilih.',
        ),
        backgroundColor: Color(0xFFE04A4A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================
  // DESAIN INPUT
  // ==========================================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9BAAC0),
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF6786AD),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFDCE6F3),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFDCE6F3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: blue,
          width: 1.8,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.8,
        ),
      ),
    );
  }

  // ==========================================
  // KARTU PILIH ROLE
  // ==========================================

  Widget _roleCard({
    required String role,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;

    return Expanded(
      child: Material(
        color: isSelected ? _lightBlue : Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () => _selectRole(role),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 132,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? blue
                    : const Color(0xFFE1E9F4),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? blue
                      : const Color(0xFF7790AC),
                  size: 28,
                ),
                const SizedBox(height: 9),
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
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // HAPUS CONTROLLER SAAT HALAMAN DITUTUP
  // ==========================================

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ==========================================
  // TAMPILAN HALAMAN LOGIN
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    // ==================================
                    // LOGO TELECARE AI
                    // ==================================

                    Center(
                      child: Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF168CF2),
                              Color(0xFF16C9AD),
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: blue.withValues(
                                alpha: 0.16,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.monitor_heart_rounded,
                          color: Colors.white,
                          size: 45,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'TeleCare AI',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Layanan Kesehatan Jarak Jauh\n'
                      'Berbasis AI',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blueGrey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 34),

                    // ==================================
                    // JUDUL LOGIN
                    // ==================================

                    const Text(
                      'Masuk ke Akun',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Pilih peran dan masukkan '
                      'akun Anda untuk melanjutkan.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blueGrey,
                      ),
                    ),

                    const SizedBox(height: 23),

                    // ==================================
                    // PILIH PASIEN ATAU DOKTER
                    // ==================================

                    Row(
                      children: [
                        _roleCard(
                          role: 'pasien',
                          title: 'Pasien',
                          subtitle: 'Chat AI & Dokter',
                          icon: Icons.person_rounded,
                        ),
                        const SizedBox(width: 12),
                        _roleCard(
                          role: 'dokter',
                          title: 'Dokter',
                          subtitle: 'Konsultasi Pasien',
                          icon: Icons.medical_services_rounded,
                        ),
                      ],
                    ),

                    const SizedBox(height: 26),

                    // ==================================
                    // USERNAME
                    // ==================================

                    const Text(
                      'Username',
                      style: TextStyle(
                        color: navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      textCapitalization:
                          TextCapitalization.none,
                      autocorrect: false,
                      decoration: _inputDecoration(
                        hint: 'Masukkan username',
                        icon: Icons.person_outline_rounded,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Username wajib diisi';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    // ==================================
                    // PASSWORD
                    // ==================================

                    const Text(
                      'Password',
                      style: TextStyle(
                        color: navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _submitLogin();
                      },
                      decoration: _inputDecoration(
                        hint: 'Masukkan password',
                        icon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password wajib diisi';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    // ==================================
                    // TOMBOL MASUK
                    // ==================================

                    SizedBox(
                      height: 54,
                      child: FilledButton(
                        onPressed: _submitLogin,
                        style: FilledButton.styleFrom(
                          backgroundColor: blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              'Masuk ke TeleCare AI',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 19,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ==================================
                    // FOOTER
                    // ==================================

                    const Text(
                      'TeleCare AI - Layanan Kesehatan Jarak Jauh',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
