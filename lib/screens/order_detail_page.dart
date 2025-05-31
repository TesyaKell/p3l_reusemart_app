import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_models.dart';
import '../services/order_service.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Order _order;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String formatDateOnly(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _showUpdateStatusDialog() async {
    bool isLoading = false;

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Status Pengiriman'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Pesanan: ${_order.noNota}'),
                    const SizedBox(height: 8),
                    Text('Status saat ini: ${_order.status}'),
                    const SizedBox(height: 16),
                    if (isLoading) ...[
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFE9C8CE),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Memproses...'),
                    ] else ...[
                      const Text('Yakin ingin menandai sebagai selesai?'),
                    ],
                  ],
                ),
              ),
              actions: isLoading
                  ? []
                  : [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color.fromARGB(
                            255,
                            188,
                            11,
                            11,
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final success =
                                await OrderService.updateOrderStatus(
                                  _order.noNota,
                                  'Selesai',
                                );
                            Navigator.of(
                              context,
                            ).pop(success ? 'Selesai' : null);
                          } catch (e) {
                            Navigator.of(context).pop();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            118,
                            188,
                            120,
                          ),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Tandai Selesai'),
                      ),
                    ],
            );
          },
        );
      },
    );

    if (result == 'Selesai') {
      setState(() {
        _order = Order(
          noNota: _order.noNota,
          idKurirPegawai: _order.idKurirPegawai,
          idPembeli: _order.idPembeli,
          tanggalPesan: _order.tanggalPesan,
          tanggalLunas: _order.tanggalLunas,
          tanggalAmbilKirim: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          tambahPoin: _order.tambahPoin,
          poinSebelum: _order.poinSebelum,
          poinSetelah: _order.poinSetelah,
          tipeDelivery: _order.tipeDelivery,
          ongkir: _order.ongkir,
          alamatPengiriman: _order.alamatPengiriman,
          totalHargaJualBersih: _order.totalHargaJualBersih,
          buktiPembayaran: _order.buktiPembayaran,
          status: 'Selesai',
          komisiPenitip: _order.komisiPenitip,
          totalPembayaran: _order.totalPembayaran,
          tukarPoin: _order.tukarPoin,
          detailTransaksi: _order.detailTransaksi,
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status berhasil diupdate menjadi Selesai'),
            backgroundColor: Color(0xFFE9C8CE),
          ),
        );
        // Pop back to orders page with result
        Navigator.pop(context, 'updated');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nota Pengiriman'),
        backgroundColor: const Color(0xFFE9C8CE),
        actions: [
          if (_order.status == 'Dikirim' && !_isUpdating)
            IconButton(
              onPressed: _showUpdateStatusDialog,
              icon: const Icon(Icons.check_circle_outline),
              tooltip: 'Update Status',
            ),
          if (_isUpdating)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9C8CE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'ReUseMart',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Order Info
                _buildInfoRow('No Nota', _order.noNota),
                _buildInfoRow('Tanggal pesan', formatDate(_order.tanggalPesan)),
                if (_order.tanggalLunas != null)
                  _buildInfoRow('Lunas pada', formatDate(_order.tanggalLunas!)),
                if (_order.tanggalAmbilKirim != null)
                  _buildInfoRow(
                    'Tanggal Kirim',
                    formatDateOnly(_order.tanggalAmbilKirim!),
                  ),
                _buildInfoRow('Status', _order.status),

                const Divider(height: 24),

                // Customer Info
                _buildInfoRow('Pembeli', _order.idPembeli),
                _buildInfoRow('Alamat', _order.alamatPengiriman),
                _buildInfoRow('Delivery', '${_order.tipeDelivery}'),

                const Divider(height: 24),

                // Items
                ..._order.detailTransaksi
                    .map(
                      (detail) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.namaBarang,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Qty: 1 x ${formatCurrency(detail.hargaJualBersih)}',
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    )
                    .toList(),

                const Divider(height: 24),

                // Totals
                _buildInfoRow(
                  'Total',
                  formatCurrency(_order.totalHargaJualBersih),
                ),
                if (_order.ongkir > 0)
                  _buildInfoRow('Ongkos Kirim', formatCurrency(_order.ongkir)),
                if (_order.tukarPoin > 0)
                  _buildInfoRow(
                    'Potongan Poin',
                    '- ${formatCurrency(_order.tukarPoin)}',
                  ),
                const Divider(),
                _buildInfoRow(
                  'Total',
                  formatCurrency(_order.totalPembayaran),
                  isTotal: true,
                ),

                const SizedBox(height: 16),

                // Points Info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Poin dari pesanan ini: ${_order.tambahPoin}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      //Text('Poin sebelum: ${_order.poinSebelum}'),
                      Text(
                        'Total poin: ${_order.poinSetelah}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
