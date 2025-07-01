import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_models.dart';
import '../constants/api.dart';

import 'package:flutter/material.dart';



class BarangService {
  static Future<List<Barang>> fetchBarangTersedia() async {
    final url = Uri.parse(Api.barangTersedia);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Filter status Tersedia
      return data
          .map((json) => Barang.fromJson(json))
          .where((b) => b.status == 'Tersedia')
          .toList();
    } else {
      throw Exception('Gagal mengambil data barang');
    }
  }

}

