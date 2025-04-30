import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/invoice.dart';

class InvoiceService {
  final String baseUrl = 'http://localhost:5000/api/invoices';

  Future<List<Invoice>> getInvoices() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Invoice.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load invoices');
    }
  }

  Future<Invoice> createInvoice(Invoice invoice) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(invoice.toJson()),
    );

    if (response.statusCode == 201) {
      return Invoice.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create invoice');
    }
  }

  Future<void> deleteInvoice(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete invoice');
    }
  }
}
