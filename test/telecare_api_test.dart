import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:telehalth_aplikasi/services/telecare_api.dart';

void main() {
  test('sends symptom details and returns the Grok response', () async {
    Map<String, dynamic>? requestBody;
    final api = TeleCareApi(
      baseUrl: 'http://localhost:3000',
      client: MockClient((request) async {
        expect(request.url.path, '/chat');
        requestBody = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({'reply': 'Jawaban edukasi'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final reply = await api.getEducation(
      complaint: 'batuk',
      duration: '1–3 hari',
      frequency: 'Kadang-kadang',
      detail: 'batuk kering',
    );

    expect(reply, 'Jawaban edukasi');
    expect(requestBody, {
      'complaint': 'batuk',
      'duration': '1–3 hari',
      'frequency': 'Kadang-kadang',
      'detail': 'batuk kering',
    });
  });

  test('surfaces backend errors instead of fabricating an answer', () async {
    final api = TeleCareApi(
      baseUrl: 'http://localhost:3000',
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'error': 'Backend belum dikonfigurasi.'}),
          503,
          headers: {'content-type': 'application/json'},
        ),
      ),
    );

    await expectLater(
      api.getEducation(
        complaint: 'demam',
        duration: 'Hari ini',
        frequency: 'Sering',
        detail: '',
      ),
      throwsA(
        isA<TeleCareApiException>().having(
          (error) => error.message,
          'message',
          'Backend belum dikonfigurasi.',
        ),
      ),
    );
  });
}
