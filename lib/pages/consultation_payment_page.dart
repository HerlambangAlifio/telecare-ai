
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'doctor_chat_page.dart';

// ======================================
// METODE PEMBAYARAN SIMULASI
// ======================================

enum PaymentMethod {
  qris,
  bankTransfer,
  eWallet,
}

// ======================================
// HALAMAN PEMBAYARAN
// ======================================

class ConsultationPaymentPage extends StatefulWidget {
  const ConsultationPaymentPage({super.key});

  @override
  State<ConsultationPaymentPage> createState() =>
      _ConsultationPaymentPageState();
}

class _ConsultationPaymentPageState
    extends State<ConsultationPaymentPage> {
  static const Color background = Color(0xFFF6F9FF);
  static const Color lightBlue = Color(0xFFEAF3FF);

  PaymentMethod _selectedMethod = PaymentMethod.qris;

  // Data fiktif untuk demonstrasi
  static const String doctorName =
      'dr. Salsabila Putri, Sp.OG';

  static const String consultationPrice = 'Rp35.000';

  String _methodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.qris:
        return 'QRIS';
      case PaymentMethod.bankTransfer:
        return 'Transfer Bank';
      case PaymentMethod.eWallet:
        return 'E-Wallet';
    }
  }

  String _methodDescription(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.qris:
        return 'Pembayaran menggunakan QRIS (simulasi)';
      case PaymentMethod.bankTransfer:
        return 'Transfer melalui bank (simulasi)';
      case PaymentMethod.eWallet:
        return 'Dompet digital (simulasi)';
    }
  }

  IconData _methodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.qris:
        return Icons.qr_code_rounded;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance_rounded;
      case PaymentMethod.eWallet:
        return Icons.account_balance_wallet_rounded;
    }
  }

  // ======================================
  // PILIHAN METODE PEMBAYARAN
  // ======================================

  Widget _paymentOption(PaymentMethod method) {
    final isSelected = _selectedMethod == method;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isSelected ? lightBlue : Colors.white,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: () {
            setState(() {
              _selectedMethod = method;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: isSelected
                    ? blue
                    : const Color(0xFFE3EAF4),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : lightBlue,
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                  child: Icon(
                    _methodIcon(method),
                    color: blue,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        _methodName(method),
                        style: const TextStyle(
                          color: navy,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _methodDescription(method),
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected
                      ? blue
                      : Colors.blueGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======================================
  // BARIS RINCIAN HARGA
  // ======================================

  Widget _priceRow(
    String title,
    String price, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isTotal
                    ? navy
                    : Colors.blueGrey,
                fontWeight: isTotal
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: isTotal ? 14 : 13,
              ),
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: isTotal ? blue : navy,
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 20 : 14,
            ),
          ),
        ],
      ),
    );
  }

  // ======================================
  // KONFIRMASI PEMBAYARAN SIMULASI
  // ======================================

  Future<void> _confirmPayment() async {
    final method = _methodName(_selectedMethod);

    final shouldContinue = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Column(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Color(0xFFE7F8F0),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF14846C),
                  size: 46,
                ),
              ),

              SizedBox(height: 13),

              Text(
                'Simulasi Berhasil!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          content: Text(
            'Konfirmasi pembayaran simulasi melalui '
            '$method telah selesai.\n\n'
            'Tidak ada uang yang ditransfer.\n\n'
            'Kamu sekarang dapat melanjutkan '
            'ke Chat Dokter.',
            textAlign: TextAlign.center,
          ),

          actionsAlignment:
              MainAxisAlignment.center,

          actions: [
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: blue,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(
                Icons.chat_rounded,
              ),
              label: const Text(
                'Masuk Chat Dokter',
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldContinue != true) return;

    // Halaman pembayaran diganti dengan Chat Dokter.
    // Tidak ada transaksi sungguhan.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DoctorChatPage(
          role: 'pasien',
        ),
      ),
    );
  }

  // ======================================
  // TAMPILAN HALAMAN
  // ======================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: navy,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Pembayaran Konsultasi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            18, 22, 18, 30,
          ),
          children: [
            const Text(
              'Ringkasan Konsultasi',
              style: TextStyle(
                color: navy,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Periksa rincian konsultasi '
              'sebelum melanjutkan pembayaran.',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // KARTU RINCIAN BIAYA
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(21),
                border: Border.all(
                  color: const Color(0xFFE3EAF4),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 57,
                        height: 57,
                        decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.medical_services_rounded,
                          color: blue,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorName,
                              style: TextStyle(
                                color: navy,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Poli Kandungan - Chat',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Konsultasi Simulasi',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  _priceRow(
                    'Biaya Konsultasi',
                    consultationPrice,
                  ),

                  _priceRow(
                    'Biaya Layanan',
                    'Rp0',
                  ),

                  const Divider(height: 22),

                  _priceRow(
                    'Total Pembayaran (Simulasi)',
                    consultationPrice,
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            const Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),

            const SizedBox(height: 14),

            // METODE PEMBAYARAN
            _paymentOption(PaymentMethod.qris),

            _paymentOption(
              PaymentMethod.bankTransfer,
            ),

            _paymentOption(PaymentMethod.eWallet),

            const SizedBox(height: 15),

            // CATATAN SIMULASI
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: blue,
                  ),

                  SizedBox(width: 11),

                  Expanded(
                    child: Text(
                      'Fitur ini hanya simulasi untuk '
                      'demonstrasi TeleCare AI. '
                      'Tidak ada QR pembayaran asli, '
                      'nomor rekening, atau transaksi '
                      'uang sungguhan.',
                      style: TextStyle(
                        color: navy,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TOMBOL KONFIRMASI
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: _confirmPayment,
                style: FilledButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
                icon: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 20,
                ),
                label: const Text(
                  'Konfirmasi Pembayaran (Simulasi)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
