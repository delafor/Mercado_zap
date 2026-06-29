import 'dart:convert';

import 'package:http/http.dart' as http;

class PaymentService {
  final String baseUrl = 'https://mercado-zap.onrender.com';

  Future<Map<String, dynamic>> createPixPayment(double amount) async {
    final response = await http.post(
      // aqui da um erro de HandshakeException (HandshakeException: Connection terminated during handshake)
      Uri.parse('$baseUrl/payments/pix'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amount}),
    ); // aqui eu posso colocar um timeout pq se o backend travar o app n fica preso

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> checkPayment(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/payments/$id'));

    return jsonDecode(response.body);
  }
}
