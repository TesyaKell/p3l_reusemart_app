import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Barang.dart';
import '../constants/api.dart';
import '../screens/beranda.dart';

Future<List<Barang>> fetchBarang() async {
  try {
    final response = await http.get(Uri.parse(Api.barang));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Barang.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load barang: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Network error: $e');
  }
}

class TentangKamiPage extends StatefulWidget {
  const TentangKamiPage({Key? key}) : super(key: key);

  @override
  _TentangKamiPageState createState() => _TentangKamiPageState();
}

class _TentangKamiPageState extends State<TentangKamiPage> {
  late Future<List<Barang>> futureBarang;

  @override
  void initState() {
    super.initState();
    futureBarang = fetchBarang();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 12.0 : 16.0;
    final gridCrossAxisCount = screenWidth < 600
        ? 2
        : (screenWidth < 900 ? 3 : 4);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<Barang>>(
        future: futureBarang,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
                strokeWidth: 3,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          futureBarang = fetchBarang();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Coba Lagi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            final List<Barang> products = snapshot.data != null
                ? snapshot.data!
                      .where((product) => product.status == 'Tersedia')
                      .toList()
                : [];

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  futureBarang = fetchBarang();
                });
              },
              color: Colors.green[600],
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tombol di atas
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Beranda",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TentangKamiPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Informasi Umum",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Jarak antara tombol dan konten berikutnya
                    SizedBox(height: padding),

                    _buildCompanyHeadline(context),
                    SizedBox(height: padding),
                    _buildCompanyDescription(),
                    SizedBox(height: padding * 2),
                    _buildProductsSection(
                      products,
                      gridCrossAxisCount,
                      padding,
                    ),
                    SizedBox(height: padding),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCompanyHeadline(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          height: 1.3,
          fontSize: 28,
        ),
        children: const [
          TextSpan(text: 'Produk Pertama '),
          TextSpan(
            text: 'Kali Hadir\n',
            style: TextStyle(color: Color(0xFFD63384)),
          ),
          TextSpan(text: 'Sejak '),
          TextSpan(
            text: 'Hari Pertama NIGGA\n',
            style: TextStyle(color: Color(0xFFD63384)),
          ),
          TextSpan(text: 'ReUseMart Berdiri '),
          TextSpan(
            text: 'Tahun 2022',
            style: TextStyle(color: Color(0xFFD63384)),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            'Sejak awal berdirinya pada tahun 2022, ReUseMart telah menghadirkan berbagai barang bekas '
            'berkualitas sebagai solusi belanja ramah lingkungan. Produk-produk seperti tas second brand ternama, '
            'sepatu bekas branded, dan peralatan rumah tangga layak pakai menjadi favorit pelanggan sejak hari pertama.',
            style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
          ),
          SizedBox(height: 12),
          Text(
            'ReUseMart berkomitmen menciptakan lingkungan berkelanjutan dengan mengedepankan konsep reuse. Setiap '
            'barang melalui proses kurasi dan pembersihan untuk memastikan kualitas terbaik sebelum dijual kembali.',
            style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(
    List<Barang> products,
    int crossAxisCount,
    double padding,
  ) {
    if (products.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Tidak ada produk tersedia saat ini',
            style: TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Produk Unggulan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: padding),
        GridView.builder(
          itemCount: products.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: padding,
            crossAxisSpacing: padding,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return AnimatedScale(
              scale: 1.0,
              duration: Duration(milliseconds: 300 + (index * 100)),
              child: _buildProductCard(product, context),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(Barang product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: Image.network(
                  'http://192.168.1.52:8000/storage/${product.fotoProduk[0]}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[100],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.green[400],
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.namaBarang,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.deskripsi,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
