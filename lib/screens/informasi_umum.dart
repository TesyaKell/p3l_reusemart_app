import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Barang.dart';
import '../constants/api.dart';

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
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 12.0 : 16.0;
    final gridCrossAxisCount = screenWidth < 400 ? 2 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Kami'),
        backgroundColor: Colors.pink[400],
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Barang>>(
        future: futureBarang,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          futureBarang = fetchBarang();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Filter available products
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
              color: Colors.green,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company headline
                    _buildCompanyHeadline(context),
                    SizedBox(height: padding),

                    // Company description
                    _buildCompanyDescription(),
                    SizedBox(height: padding * 1.5),

                    // Info cards section
                    _buildInfoCardsSection(gridCrossAxisCount, padding),
                    SizedBox(height: padding * 2),

                    // Products section
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
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          height: 1.3,
        ),
        children: const [
          TextSpan(text: 'Produk Pertama '),
          TextSpan(
            text: 'Kali Hadir\n',
            style: TextStyle(color: Color(0xFFD63384)),
          ),
          TextSpan(text: 'Sejak '),
          TextSpan(
            text: 'Hari Pertama\n',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Sejak awal berdirinya pada tahun 2022, ReUseMart telah menghadirkan berbagai barang bekas '
          'berkualitas sebagai solusi belanja ramah lingkungan. Produk-produk seperti tas second brand ternama, '
          'sepatu bekas branded, dan peralatan rumah tangga layak pakai menjadi favorit pelanggan sejak hari pertama.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        SizedBox(height: 8),
        Text(
          'ReUseMart berkomitmen menciptakan lingkungan berkelanjutan dengan mengedepankan konsep reuse. Setiap '
          'barang melalui proses kurasi dan pembersihan untuk memastikan kualitas terbaik sebelum dijual kembali.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildInfoCardsSection(int crossAxisCount, double padding) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
       
      ],
    );
  }

  Widget _buildProductsSection(
    List<Barang> products,
    int crossAxisCount,
    double padding,
  ) {
    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Tidak ada produk tersedia saat ini',
            style: TextStyle(fontSize: 16),
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductCard(product, context);
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: SizedBox(
                height: 120,
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
                          color: Colors.green[300],
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Product details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.namaBarang,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.deskripsi,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const InfoCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
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
                        color: Colors.green[300],
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Text section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
