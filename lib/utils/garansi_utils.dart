import 'package:flutter/material.dart';

Color getWarrantyColor(String? batasGaransiStr) {
  if (batasGaransiStr == null) return Colors.grey;
  final batasGaransi = DateTime.tryParse(batasGaransiStr);
  if (batasGaransi == null) return Colors.grey;

  final now = DateTime.now();
  final days = batasGaransi.difference(now).inDays;

  if (days < 0) return Colors.grey;
  if (days <= 7) return Colors.red;
  if (days <= 30) return Colors.orange;
  return Colors.green;
}

String getWarrantyStatus(String? batasGaransiStr) {
  if (batasGaransiStr == null) return 'Tidak tersedia';
  final batasGaransi = DateTime.tryParse(batasGaransiStr);
  if (batasGaransi == null) return 'Tidak valid';

  final now = DateTime.now();
  final days = batasGaransi.difference(now).inDays;

  if (days < 0) return 'Garansi habis';
  if (days <= 7) return 'Hampir habis';
  if (days <= 30) return 'Kurang dari sebulan';
  return 'Masih lama';
}
