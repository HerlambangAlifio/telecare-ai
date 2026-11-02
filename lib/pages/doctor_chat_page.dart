import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';

class DoctorChatPage extends StatefulWidget {
  const DoctorChatPage({super.key});

  @override
  State<DoctorChatPage> createState() => _DoctorChatPageState();
}

class _DoctorChatPageState extends State<DoctorChatPage> {
  final controller = TextEditingController();
  final messages = <({String text, bool mine})>[
    (
      text: 'Halo Dok, saya ingin berkonsultasi mengenai keluhan saya.',
      mine: true,
    ),
    (
      text:
          'Halo! Ini adalah simulasi chat dokter untuk demonstrasi aplikasi TeleCare AI. Tidak ada dokter sungguhan yang menerima pesan ini.',
      mine: false,
    ),
  ];

  void send() {
    final message = controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      messages.add((text: message, mine: true));
      messages.add((
        text:
            'Terima kasih. Ini balasan otomatis simulasi, bukan nasihat dokter. Jika keluhan berat atau darurat, segera hubungi fasilitas kesehatan.',
        mine: false,
      ));
      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Column(
        children: [
          Text('Konsultasi Dokter'),
          Text(
            'Simulasi • bukan dokter aktif',
            style: TextStyle(fontSize: 11, color: Colors.teal),
          ),
        ],
      ),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: panel(
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFFE4F2FF),
                  child: Icon(Icons.person, color: blue),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dokter Virtual (Simulasi)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Percakapan demonstrasi • offline',
                        style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return Align(
                alignment: message.mine
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * .82,
                  ),
                  decoration: BoxDecoration(
                    color: message.mine ? blue : const Color(0xFFEAF0F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.mine ? Colors.white : navy,
                      height: 1.4,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => send(),
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan Anda...',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: send,
                  icon: const Icon(Icons.send),
                  style: IconButton.styleFrom(backgroundColor: blue),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
