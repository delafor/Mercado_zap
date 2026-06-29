import 'dart:async';

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

      print('RESPOSTA API:');
      print(response);

      final data = response['data'];

      //qrCode = data['qrCodeImage'];
      pixCode = data['brCode'];
      print('PIX CODE: $pixCode');
      print('TAMANHO: ${pixCode.length}');
      paymentId = data['id'];

      loading = false;

      notifyListeners();
    } catch (e) {
      loading = false;

      notifyListeners();

      print('ERRO AO GERAR PIX');
      print(e);
    }
  }

  // gerar qr code
  // void startChecking() {
  //   timer = Timer.periodic(const Duration(seconds: 5), (_) async {
  //     try {
  //       final response = await service.checkPayment(paymentId);

  //       print(response);

  //       if (response['data']['status'] == 'PAID') {
  //         approved = true;

  //         timer?.cancel();

  //         notifyListeners();
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   });
  // }
  //gerar qrcode manual com aprovacao automatica
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
