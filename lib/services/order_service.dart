import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:p3l_reusemart/models/komisi_detail.dart';
import 'package:p3l_reusemart/utils/shared_prefs.dart';

import '../constants/api.dart';
import '../models/order_models.dart';

class OrderService {
  static Future<OrderResponse> fetchOrders() async {
    try {
      final url = Uri.parse(Api.pengirimanKurir);
      print('Calling API: $url');
      final token = SharedPrefsUtil.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }
      print('Using token: $token');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token}', // Assuming you have a token
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return OrderResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in OrderService.fetchOrders: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<bool> updateOrderStatus(String noNota, String status) async {
    try {
      final url = Uri.parse('${Api.pengirimanKurir}/$noNota');
      print('Updating order status: $url');

      final token = SharedPrefsUtil.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['success'] ?? false;
      } else {
        throw Exception(
          'Failed to update order status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in OrderService.updateOrderStatus: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<OrderResponse> fetchHistory() async {
    try {
      final url = Uri.parse(Api.historyPengirimanKurir);
      print('Calling History API: $url');

      final token = SharedPrefsUtil.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }
      print('Using token: $token');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('History Response status: ${response.statusCode}');
      print('History Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return OrderResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in OrderService.fetchHistory: $e');
      throw Exception('Network error: $e');
    }
  }
  static Future<OrderResponse> fetchMerchandise() async {
    try {
      final url = Uri.parse(Api.merchandise);
      print('Calling Merchandise API: $url');

      final token = SharedPrefsUtil.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }
      print('Using token: $token');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('History Response status: ${response.statusCode}');
      print('History Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return OrderResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in OrderService.fetchHistory: $e');
      throw Exception('Network error: $e');
    }
  }
  static Future<List<Komisi>> fetchKomisiHunter(String idPegawai) async {
    final response = await http.get(Uri.parse('${Api.historyKomisi}/$idPegawai'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Komisi.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat komisi');
    }
  }
  
}
