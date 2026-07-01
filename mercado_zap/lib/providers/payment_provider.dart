import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService service = PaymentService();

  bool loading = false;

  String qrCode = '';
  String pixCode = '';
  String paymentId = '';

  bool approved = false;

  Timer? timer;

  Future<void> createPayment({
    required double amount,
    required dynamic provider,
  }) async {
    try {
      approved = false;
      qrCode = '';
      pixCode = '';
      paymentId = '';
      loading = true;

      notifyListeners();

      final response = await service.createPixPayment(amount);

      final data = response['data'];

      //qrCode = data['qrCodeImage'];
      pixCode = data['brCode'];

      paymentId = data['id'];

      loading = false;

      notifyListeners();
    } catch (e) {
      loading = false;

      notifyListeners();

      if (kDebugMode) {
        print('ERRO AO GERAR PIX');
      }
      print(e);
    }
  }

  void startChecking() {
    timer?.cancel();

    timer = Timer(const Duration(seconds: 10), () {
      approved = true;

      notifyListeners();
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }
}
