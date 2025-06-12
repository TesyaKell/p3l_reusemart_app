
import 'dart:convert';

extension FotoProdukExt on String {
  List<String> parseFotoList() {
    try {
      final decoded = jsonDecode(this);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
