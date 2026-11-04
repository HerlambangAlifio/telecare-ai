
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/telecare_api.dart';
import '../theme/app_colors.dart';

class DoctorChatPage extends StatefulWidget {
  final String role;
  final VoidCallback? onLogout;

  const DoctorChatPage({
    super.key,
    this.role = 'pasien',
    this.onLogout,
  });

  @override
  State<DoctorChatPage> createState() =>
      _DoctorChatPageState();
}

class _DoctorChatPageState extends State<DoctorChatPage> {
  final TextEditingController _controller =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  final List<Map<String, dynamic>> _messages = [];

  Timer? _timer;

  bool _loading = true;
  bool _fetching = false;
  bool _sending = false;

  String? _error;

  bool get _isDoctor => widget.role == 'dokter';

  static const Color _background = Color(0xFFF5F9FF);
  static const Color _lightBlue = Color(0xFFE7F2FF);

  @override
  void initState() {
    super.initState();

    _loadMessages();

    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _loadMessages(),
    );
  }

  // ======================================
  // MENGAMBIL PESAN
  // ======================================

  Future<void> _loadMessages() async {
    if (!mounted || _fetching) return;

    _fetching = true;

    try {
      final response = await http
          .get(
            Uri.parse('$apiBaseUrl/doctor/messages'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Gagal mengambil pesan');
      }

      final data = jsonDecode(response.body);

      if (data is! Map || data['messages'] is! List) {
        throw const FormatException(
          'Format pesan tidak valid',
        );
      }

      final updated = (data['messages'] as List)
          .map(
            (item) => Map<String, dynamic>.from(
              item as Map,
            ),
          )
          .toList();

      if (!mounted) return;

      final oldId = _messages.isEmpty
          ? null
          : _messages.last['id'];

      final newId = updated.isEmpty
          ? null
          : updated.last['id'];

      final changed =
          _messages.length != updated.length ||
          oldId != newId;

      if (changed || _loading || _error != null) {
        setState(() {
          _messages
            ..clear()
            ..addAll(updated);

          _loading = false;
          _error = null;
        });
      }

      if (changed) {
        _scrollToBottom();
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error =
            'Tidak dapat terhubung ke server. '
            'Periksa backend dan koneksi USB.';
      });
    } finally {
      _fetching = false;
    }
  }

  // ======================================
  // MENGIRIM PESAN
  // ======================================

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();

    if (text.isEmpty || _sending) return;

    setState(() {
      _sending = true;
      _error = null;
    });

    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/doctor/messages'),
            headers: const {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'sender': widget.role,
              'text': text,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 201) {
        throw Exception('Pesan gagal dikirim');
      }

      if (!mounted) return;

      _controller.clear();

      await _loadMessages();
      _scrollToBottom();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error =
            'Pesan belum terkirim. '
            'Periksa koneksi server lalu coba lagi.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  // ======================================
  // SCROLL PESAN
  // ======================================

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  // ======================================
  // LOGOUT OPSIONAL
  // ======================================

  Future<void> _confirmLogout() async {
    final logout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari Akun'),
        content: const Text(
          'Apakah Anda ingin kembali ke halaman login?',
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

    if (logout == true) {
      widget.onLogout?.call();
    }
  }

  // ======================================
  // HEADER INFORMASI KONSULTASI
  // ======================================

  Widget _buildContactCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 15, 16, 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE1EAF4),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080E4C92),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _lightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _isDoctor
                  ? Icons.person_rounded
                  : Icons.medical_services_rounded,
              color: blue,
              size: 29,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isDoctor
                      ? 'Konsultasi Pasien'
                      : 'Chat dengan Dokter',
                  style: const TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Ruang konsultasi bersama',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7EF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Demo',
              style: TextStyle(
                color: Color(0xFF168264),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================
  // BUBBLE CHAT
  // ======================================

  Widget _buildMessage(Map<String, dynamic> message) {
    final sender = message['sender']?.toString() ?? '';
    final text = message['text']?.toString() ?? '';

    final mine = sender == widget.role;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: mine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine) ...[
            CircleAvatar(
              radius: 17,
              backgroundColor: _lightBlue,
              child: Icon(
                sender == 'dokter'
                    ? Icons.medical_services_rounded
                    : Icons.person_rounded,
                color: blue,
                size: 19,
              ),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth:
                    MediaQuery.sizeOf(context).width * 0.76,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: mine ? const Color(0xFFD4E9FF) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(mine ? 18 : 5),
                  bottomRight: Radius.circular(mine ? 5 : 18),
                ),
                border: mine
                    ? null
                    : Border.all(
                        color: const Color(0xFFE4EBF5),
                      ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x080E4C92),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sender == 'dokter'
                        ? 'Dokter'
                        : 'Pasien',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: mine
                          ? const Color(0xFF1864B7)
                          : const Color(0xFF14877D),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    text,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (mine) const SizedBox(width: 6),
        ],
      ),
    );
  }

  // ======================================
  // BAGIAN INPUT PESAN
  // ======================================

  Widget _buildMessageInput() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE7EDF5),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: !_sending,
                minLines: 1,
                maxLines: 4,
                maxLength: 1000,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  hintStyle: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 13,
                  ),
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFF7F9FD),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Color(0xFFE0E7F1),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Color(0xFFE0E7F1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: blue,
                    ),
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),

            const SizedBox(width: 10),

            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: IconButton.filled(
                tooltip: 'Kirim Pesan',
                onPressed: _sending
                    ? null
                    : _sendMessage,
                style: IconButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(46, 46),
                ),
                icon: _sending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
                        size: 21,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ======================================
  // HALAMAN UTAMA
  // ======================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: navy,
        surfaceTintColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isDoctor
                  ? 'Konsultasi Pasien'
                  : 'Konsultasi Dokter',
              style: const TextStyle(
                color: navy,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _isDoctor
                  ? 'Masuk sebagai Dokter'
                  : 'Masuk sebagai Pasien',
              style: const TextStyle(
                color: Color(0xFF158D83),
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          if (widget.onLogout != null)
            IconButton(
              tooltip: 'Keluar Akun',
              onPressed: _confirmLogout,
              icon: const Icon(
                Icons.logout_rounded,
              ),
            ),
        ],
      ),

      body: Column(
        children: [
          _buildContactCard(),

          // Indikator tanggal percakapan
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE7EEF8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Percakapan',
                style: TextStyle(
                  color: Color(0xFF5F718C),
                  fontSize: 11,
                ),
              ),
            ),
          ),

          if (_error != null)
            Container(
              margin: const EdgeInsets.fromLTRB(
                16, 0, 16, 10,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0EF),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    color: Color(0xFFD35C54),
                    size: 21,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: Color(0xFFB44844),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _loadMessages,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),

          Expanded(
            child: _loading && _messages.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _messages.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 45,
                              color: Color(0xFFB8CBE4),
                            ),
                            SizedBox(height: 14),
                            Text(
                              'Belum ada pesan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: navy,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Mulai percakapan sekarang.',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(
                          15, 10, 15, 20,
                        ),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessage(
                            _messages[index],
                          );
                        },
                      ),
          ),

          _buildMessageInput(),
        ],
      ),
    );
  }
}