import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/Barang.dart';
import '../../utils/shared_prefs.dart';
import 'detail_barang.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiwayatTransaksiPage extends StatefulWidget {
  const RiwayatTransaksiPage({Key? key}) : super(key: key);

  @override
  State<RiwayatTransaksiPage> createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  late Future<List<Barang>> _futureTransaksi;
  bool _isGridView = true;
  final String baseUrl = 'http://192.168.1.52:8000';

  @override
  void initState() {
    super.initState();
    _futureTransaksi = fetchTransaksi();
  }

  Future<List<Barang>> fetchTransaksi() async {
    final token = await SharedPrefsUtil.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/riwayat-penitipan'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = data['barangTersedia'] as List;
      return list.map((json) => Barang.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data transaksi');
    }
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String getImageUrl(Barang product) {
    if (product.fotoProduk.isNotEmpty) {
      return '$baseUrl/storage/${product.fotoProduk[0]}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   title: const Text(
      //     'Riwayat PENITIPAN',
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      //   ),
      //   backgroundColor: Colors.orange[600],
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //       icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
      //       onPressed: () {
      //         setState(() {
      //           _isGridView = !_isGridView;
      //         });
      //       },
      //     ),
      //   ],
      // ),
      body: FutureBuilder<List<Barang>>(
        future: _futureTransaksi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat penitipan',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final transaksiList = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _futureTransaksi = fetchTransaksi();
              });
            },
            child: _isGridView
                ? _buildGridView(transaksiList)
                : _buildListView(transaksiList),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List<Barang> transaksiList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: transaksiList.length,
        itemBuilder: (context, index) {
          final barang = transaksiList[index];
          return _buildProductCard(barang);
        },
      ),
    );
  }

  Widget _buildListView(List<Barang> transaksiList) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: transaksiList.length,
      itemBuilder: (context, index) {
        final barang = transaksiList[index];
        return _buildProductListItem(barang);
      },
    );
  }

  Widget _buildProductCard(Barang barang) {
    final imageUrl = getImageUrl(barang);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailBarangPage(barang: barang, baseUrl: baseUrl),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section - Fixed height
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Colors.grey[200],
              ),
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.orange[600]!,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey[400],
                    ),
            ),
            // Content section - Flexible
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product name - flexible height
                    Flexible(
                      child: Text(
                        barang.namaBarang,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Text(
                      formatCurrency(barang.harga),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[600],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Status badge
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(barang.status),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          barang.status,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListItem(Barang barang) {
    final imageUrl = getImageUrl(barang);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailBarangPage(barang: barang, baseUrl: baseUrl),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.orange[600]!,
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported,
                              size: 30,
                              color: Colors.grey[400],
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.image_not_supported,
                        size: 30,
                        color: Colors.grey[400],
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barang.namaBarang,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatCurrency(barang.harga),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(barang.status),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            barang.status,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'tersedia':
        return Colors.green;
      case 'terjual':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
