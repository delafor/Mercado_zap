import 'dart:convert';

import 'package:http/http.dart' as http;

/// Talks to the Mercado Zap backend to create and track PIX payments.
class PaymentService {
  /// Backend base URL. Override at build/run time, e.g.:
  ///   flutter run --dart-define=BACKEND_URL=http://10.0.2.2:3000
  static const String baseUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'https://mercado-zap.onrender.com',
  );

  static const Duration _timeout = Duration(seconds: 15);

  /// Creates a PIX charge. The backend owns prices; the app only sends the
  /// product ids and quantities selected by the user.
  Future<Map<String, dynamic>> createPixPayment(
    List<Map<String, int>> items,
  ) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/payments/pix'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'items': items}),
        )
        .timeout(_timeout);

    if (response.statusCode != 201) {
      throw PaymentException('Failed to create PIX payment (${response.statusCode})');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Fetches a payment by id, including its current `status`.
  Future<Map<String, dynamic>> checkPayment(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/payments/$id')).timeout(_timeout);

    if (response.statusCode != 200) {
      throw PaymentException('Failed to fetch payment (${response.statusCode})');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

class PaymentException implements Exception {
  PaymentException(this.message);

  final String message;

  @override
  String toString() => 'PaymentException: $message';
}
