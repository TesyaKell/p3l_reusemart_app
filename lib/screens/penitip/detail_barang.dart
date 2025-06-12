import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async' as async;
import '../../models/Barang.dart';

class DetailBarangPage extends StatefulWidget {
  final Barang barang;
  final String baseUrl;

  const DetailBarangPage({
    Key? key,
    required this.barang,
    required this.baseUrl,
  }) : super(key: key);

  @override
  State<DetailBarangPage> createState() => _DetailBarangPageState();
}

class _DetailBarangPageState extends State<DetailBarangPage> {
  int _currentImageIndex = 0;
  late PageController _pageController;
  async.Timer? _timer;

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    final images = getImageUrls();
    if (images.length <= 1) return;

    _timer = async.Timer.periodic(Duration(seconds: 3), (async.Timer timer) {
      if (_currentImageIndex < images.length - 1) {
        _currentImageIndex++;
      } else {
        _currentImageIndex = 0;
      }

      _pageController.animateToPage(
        _currentImageIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  List<String> getImageUrls() {
    if (widget.barang.fotoProduk.isNotEmpty) {
      return widget.barang.fotoProduk
          .map((foto) => '${widget.baseUrl}/storage/$foto')
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            flexibleSpace: FlexibleSpaceBar(background: _buildImageViewer()),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: _showInfoDialog,
              ),
            ],
          ),
          SliverToBoxAdapter(child: _buildProductDetails()),
        ],
      ),
    );
  }

  Widget _buildImageViewer() {
    final images = getImageUrls();

    if (images.isEmpty) {
      return Container(
        width: double.infinity,
        height: 300,
        color: Colors.grey[200],
        child: Icon(
          Icons.image_not_supported,
          size: 80,
          color: Colors.grey[400],
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
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
                      size: 80,
                      color: Colors.grey[400],
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentImageIndex + 1}/${images.length}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name and Price
          Text(
            widget.barang.namaBarang,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            formatCurrency(widget.barang.harga),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.orange[600],
            ),
          ),
          const SizedBox(height: 16),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(widget.barang.status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.barang.status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),

          _buildSection('Deskripsi Produk', widget.barang.deskripsi),
          const SizedBox(height: 24),

          _buildDetailsSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Produk',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildDetailRow('Kode Barang', widget.barang.kodeBarang),
              _buildDetailRow('Berat', '${widget.barang.beratBarang} gram'),
              if (widget.barang.garansi != null)
                _buildDetailRow('Garansi', '${widget.barang.garansi} bulan'),
              _buildDetailRow(
                'Tanggal Masuk',
                formatDate(widget.barang.tanggalMasuk),
              ),
              _buildDetailRow(
                'Tanggal Batas',
                formatDate(widget.barang.tanggalBatas),
              ),
              if (widget.barang.batasGaransi != null)
                _buildDetailRow(
                  'Batas Garansi',
                  formatDate(widget.barang.batasGaransi!),
                ),
              if (widget.barang.tanggalLaku != null)
                _buildDetailRow(
                  'Tanggal Laku',
                  formatDate(widget.barang.tanggalLaku!),
                ),
              if (widget.barang.tanggalAmbil != null)
                _buildDetailRow(
                  'Tanggal Ambil',
                  formatDate(widget.barang.tanggalAmbil!),
                  isLast: true,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600]),
              const SizedBox(width: 8),
              const Text('Informasi Barang'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kode: ${widget.barang.kodeBarang}'),
              const SizedBox(height: 4),
              Text('Status: ${widget.barang.status}'),
              const SizedBox(height: 4),
              if (widget.barang.garansi != null) ...[
                const SizedBox(height: 4),
                Text('Garansi: ${widget.barang.garansi} bulan'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'tersedia':
        return Colors.green;
      case 'terjual':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }
}
