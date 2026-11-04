
import 'package:flutter/material.dart';

import '../services/telecare_api.dart';
import '../theme/app_colors.dart';

// ==========================================
// MODEL PESAN CHAT
// ==========================================

class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime createdAt;

  _ChatMessage({
    required this.text,
    required this.isUser,
  }) : createdAt = DateTime.now();
}

// ==========================================
// HALAMAN CHAT GEMINI AI
// ==========================================

class ChatAiPage extends StatefulWidget {
  const ChatAiPage({super.key});

  @override
  State<ChatAiPage> createState() => _ChatAiPageState();
}

class _ChatAiPageState extends State<ChatAiPage> {
  final TeleCareApi _api = TeleCareApi();

  final TextEditingController _controller =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  final FocusNode _focusNode = FocusNode();

  final List<_ChatMessage> _messages = [];

  final List<Map<String, String>> _history = [];

  bool _loading = false;
  String? _error;
  String? _failedMessage;

  static const Color _background = Color(0xFFF5F9FF);
  static const Color _lightBlue = Color(0xFFE7F2FF);

  @override
  void initState() {
    super.initState();

    // Pesan pembuka dari asisten
    _messages.add(
      _ChatMessage(
        text:
            'Halo! Saya asisten AI TeleCare.\n\n'
            'Saya siap membantu memberikan informasi '
            'awal seputar kesehatan ibu, kehamilan, '
            'dan perawatan sehari-hari.\n\n'
            'Apa yang ingin Anda tanyakan?',
        isUser: false,
      ),
    );
  }

  // ==========================================
  // MENGIRIM PESAN KE GEMINI
  // ==========================================

  Future<void> _sendMessage({
    String? retryMessage,
  }) async {
    if (_loading) return;

    final text = (retryMessage ?? _controller.text).trim();

    if (text.isEmpty) return;

    if (retryMessage == null) {
      _controller.clear();

      setState(() {
        _messages.add(
          _ChatMessage(
            text: text,
            isUser: true,
          ),
        );
      });
    }

    setState(() {
      _loading = true;
      _error = null;
      _failedMessage = null;
    });

    _focusNode.unfocus();
    _scrollToBottom();

    try {
      // Kirim maksimal 10 pesan riwayat sebelumnya
      final recentHistory = _history.length <= 10
          ? List<Map<String, String>>.from(_history)
          : List<Map<String, String>>.from(
              _history.sublist(_history.length - 10),
            );

      // Menggunakan integrasi Gemini yang sudah ada
      final reply = await _api.sendChatMessage(
        message: text,
        history: recentHistory,
      );

      if (!mounted) return;

      setState(() {
        _messages.add(
          _ChatMessage(
            text: reply,
            isUser: false,
          ),
        );

        // Riwayat hanya disimpan jika AI berhasil
        _history.add({
          'role': 'user',
          'text': text,
        });

        _history.add({
          'role': 'model',
          'text': reply,
        });

        _loading = false;
        _error = null;
      });

      _scrollToBottom();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _failedMessage = text;
        _error =
            'Gagal mendapatkan jawaban AI. '
            'Periksa koneksi internet dan backend.';
      });

      _scrollToBottom();
    }
  }

  // ==========================================
  // COBA KIRIM ULANG PESAN
  // ==========================================

  void _retryLastMessage() {
    final failedMessage = _failedMessage;

    if (failedMessage == null) return;

    _sendMessage(retryMessage: failedMessage);
  }

  // ==========================================
  // ISI PERTANYAAN CEPAT
  // ==========================================

  void _fillQuestion(String question) {
    _controller.text = question;

    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: question.length),
    );

    _focusNode.requestFocus();
  }

  // ==========================================
  // SCROLL KE CHAT TERBARU
  // ==========================================

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // ==========================================
  // FORMAT JAM
  // ==========================================

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  // ==========================================
  // HEADER INFORMASI AI
  // ==========================================

  Widget _buildAssistantCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 15, 16, 12),
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
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF168CF2),
                  Color(0xFF16C9AD),
                ],
              ),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asisten TeleCare AI',
                  style: TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Didukung Gemini AI',
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
              color: const Color(0xFFE7F1FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: blue,
                  size: 12,
                ),
                SizedBox(width: 4),
                Text(
                  'AI',
                  style: TextStyle(
                    color: blue,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PESAN CHAT
  // ==========================================

  Widget _buildMessage(_ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 17,
              backgroundColor: _lightBlue,
              child: const Icon(
                Icons.smart_toy_rounded,
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
                    MediaQuery.sizeOf(context).width * 0.77,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? const Color(0xFFD4E9FF)
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(
                    message.isUser ? 18 : 5,
                  ),
                  bottomRight: Radius.circular(
                    message.isUser ? 5 : 18,
                  ),
                ),
                border: message.isUser
                    ? null
                    : Border.all(
                        color: const Color(0xFFE4EBF5),
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.isUser
                        ? 'Anda'
                        : 'TeleCare AI',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: message.isUser
                          ? const Color(0xFF1769BC)
                          : const Color(0xFF14877D),
                    ),
                  ),

                  const SizedBox(height: 6),

                  SelectableText(
                    message.text,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _formatTime(message.createdAt),
                      style: const TextStyle(
                        color: Color(0xFF8699AF),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // INDIKATOR AI MENGETIK
  // ==========================================

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 17,
            backgroundColor: _lightBlue,
            child: Icon(
              Icons.smart_toy_rounded,
              color: blue,
              size: 19,
            ),
          ),

          const SizedBox(width: 8),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE4EBF5),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: blue,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'AI sedang mengetik...',
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
    );
  }

  // ==========================================
  // PILIHAN PERTANYAAN AWAL
  // ==========================================

  Widget _buildQuickQuestions() {
    if (_messages.length > 1) {
      return const SizedBox.shrink();
    }

    const suggestions = [
      'Apa makanan sehat untuk ibu hamil?',
      'Apa tanda bahaya selama kehamilan?',
      'Olahraga apa yang aman saat hamil?',
    ];

    return Padding(
      padding: const EdgeInsets.only(
        left: 41,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contoh pertanyaan:',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 8),

          ...suggestions.map(
            (question) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: ActionChip(
                label: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 12,
                    color: blue,
                  ),
                ),
                backgroundColor: Colors.white,
                side: const BorderSide(
                  color: Color(0xFFD8E8FA),
                ),
                onPressed: () => _fillQuestion(question),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PESAN ERROR
  // ==========================================

  Widget _buildErrorCard() {
    if (_error == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: Color(0xFFD35C54),
            size: 21,
          ),

          const SizedBox(width: 10),

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
            onPressed: _loading || _failedMessage == null
                ? null
                : _retryLastMessage,
            child: const Text('Ulangi'),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // INPUT PESAN
  // ==========================================

  Widget _buildMessageInput() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          14, 11, 14, 12,
        ),
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
                focusNode: _focusNode,
                enabled: !_loading,
                minLines: 1,
                maxLines: 4,
                maxLength: 1000,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Tulis pertanyaan Anda...',
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
                tooltip: 'Kirim Pertanyaan',
                onPressed: _loading ? null : _sendMessage,
                style: IconButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(46, 46),
                ),
                icon: _loading
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
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
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ==========================================
  // TAMPILAN UTAMA
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: navy,
        surfaceTintColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat AI Gemini',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            Text(
              'Asisten Kesehatan Ibu',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF158D83),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          _buildAssistantCard(),

          // Informasi penting
          Container(
            margin: const EdgeInsets.fromLTRB(
              16, 0, 16, 12,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _lightBlue,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: blue,
                  size: 21,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Jawaban AI bersifat edukatif, '
                    'bukan diagnosis medis.',
                    style: TextStyle(
                      color: navy,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          _buildErrorCard(),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(
                15, 10, 15, 20,
              ),
              itemCount: _messages.length +
                  1 +
                  (_loading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  return _buildMessage(_messages[index]);
                }

                if (index == _messages.length) {
                  return _buildQuickQuestions();
                }

                return _buildTypingIndicator();
              },
            ),
          ),

          _buildMessageInput(),
        ],
      ),
    );
  }
}
