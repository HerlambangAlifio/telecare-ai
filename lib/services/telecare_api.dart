import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:3000',
);

class TeleCareApiException implements Exception {
  final String message;

  const TeleCareApiException(this.message);

  @override
  String toString() => message;
}

class TeleCareApi {
  TeleCareApi({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _ownsClient = client == null,
      _baseUrl = baseUrl ?? apiBaseUrl;

  final http.Client _client;
  final bool _ownsClient;
  final String _baseUrl;

  Future<String> getEducation({
    required String complaint,
    required String duration,
    required String frequency,
    required String detail,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/chat'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({
              'complaint': complaint,
              'duration': duration,
              'frequency': frequency,
              'detail': detail,
            }),
          )
          .timeout(const Duration(seconds: 70));

      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) {
        throw const TeleCareApiException(
          'Backend mengembalikan respons yang tidak valid.',
        );
      }

      if (response.statusCode != 200) {
        throw TeleCareApiException(
          data['error'] is String
              ? data['error'] as String
              : 'Gagal mendapatkan jawaban dari Grok.',
        );
      }

      final reply = data['reply'];
      if (reply is! String || reply.trim().isEmpty) {
        throw const TeleCareApiException(
          'Grok tidak mengembalikan jawaban yang dapat ditampilkan.',
        );
      }
      return reply.trim();
    } on TimeoutException {
      throw const TeleCareApiException(
        'Permintaan terlalu lama. Periksa koneksi dan coba lagi.',
      );
    } on http.ClientException {
      throw const TeleCareApiException(
        'Tidak dapat terhubung ke backend TeleCare AI.',
      );
    } on FormatException {
      throw const TeleCareApiException(
        'Backend mengembalikan respons yang tidak valid.',
      );
    }
  }

  
Future<String> sendChatMessage({
  required String message,
  required List<Map<String, String>> history,
}) async {
  try {
    final response = await _client
        .post(
          Uri.parse('$_baseUrl/chatbot'),
          headers: const {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'message': message,
            'history': history,
          }),
        )
        .timeout(const Duration(seconds: 75));

    final data = jsonDecode(response.body);

    if (data is! Map<String, dynamic>) {
      throw const TeleCareApiException(
        'Respons backend tidak valid.',
      );
    }

    if (response.statusCode != 200) {
      throw TeleCareApiException(
        data['error']?.toString() ??
            'Gagal mendapatkan jawaban AI.',
      );
    }

    final reply = data['reply'];

    if (reply is! String || reply.trim().isEmpty) {
      throw const TeleCareApiException(
        'AI tidak memberikan jawaban.',
      );
    }

    return reply.trim();
  } on TimeoutException {
    throw const TeleCareApiException(
      'AI terlalu lama merespons. Coba lagi.',
    );
  } on http.ClientException {
    throw const TeleCareApiException(
      'Tidak dapat terhubung ke backend.',
    );
  } on FormatException {
    throw const TeleCareApiException(
      'Format respons backend tidak valid.',
    );
  }
}


  void close() {
    if (_ownsClient) _client.close();
  }
}
