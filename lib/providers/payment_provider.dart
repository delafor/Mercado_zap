import 'dart:async';

import 'package:flutter/foundation.dart';

import '../services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService service = PaymentService();

  bool loading = false;

  String pixCode = '';
  String paymentId = '';

  bool approved = false;
  String? error;

  Timer? _timer;

  Future<void> createPayment({
    required List<Map<String, int>> items,
    required dynamic provider,
  }) async {
    try {
      approved = false;
      error = null;
      pixCode = '';
      paymentId = '';
      loading = true;
      notifyListeners();

      final payment = await service.createPixPayment(items);

      pixCode = payment['brCode'] as String;
      paymentId = payment['id'] as String;

      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      error = 'Não foi possível gerar o PIX. Tente novamente.';
      notifyListeners();
      debugPrint('Error creating PIX payment: $e');
    }
  }

  /// Polls the backend until the payment is confirmed (status `PAID`) or the
  /// polling window expires. Replaces the previous mocked auto-approval.
  void startChecking() {
    _timer?.cancel();
    if (paymentId.isEmpty) return;

    const interval = Duration(seconds: 4);
    const maxAttempts = 75; // ~5 minutes
    var attempts = 0;

    _timer = Timer.periodic(interval, (timer) async {
      attempts++;
      try {
        final payment = await service.checkPayment(paymentId);
        if (payment['status'] == 'PAID') {
          approved = true;
          timer.cancel();
          notifyListeners();
          return;
        }
      } catch (e) {
        // Keep polling on transient errors; just log them.
        debugPrint('Error checking payment: $e');
      }

      if (attempts >= maxAttempts) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
