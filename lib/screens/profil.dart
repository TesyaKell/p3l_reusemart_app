import 'package:flutter/material.dart';
import 'package:p3l_reusemart/screens/beranda.dart';
import '../models/user_model.dart';
import '../utils/shared_prefs.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';

class ProfilKurir extends StatelessWidget {
  const ProfilKurir({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SharedPrefsUtil.getUser();
    final role = user?.role ?? '';
    final kodeJabatan = user?.originalData['kode_jabatan'] ?? '-';
    final tanggalLahir = user?.originalData['tanggal_lahir'] ?? '-';
    final points = user?.points?.toString() ?? '-';
    final saldo = user?.balance ?? 0;

    final formattedSaldo = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(saldo);

    if (user == null) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // FOTO & NAMA
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color.fromARGB(255, 188, 99, 142),
              child: Text(
                user.name[0].toUpperCase(),
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Role dan kode jabatan hanya untuk hunter/kurir
            if (role == 'hunter' || role == 'kurir')
              Text(
                '$kodeJabatan | ${role.toUpperCase()}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              )
            else
              Text(
                role.toUpperCase(),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            const SizedBox(height: 24),

            // KARTU INFO
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Informasi Akun',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.email, 'Emaill', user.email),
                    _buildInfoRow(Icons.phone, 'Telepon', user.phone),
                    if (role == 'hunter' || role == 'kurir')
                      _buildInfoRow(Icons.cake, 'Tanggal Lahir', tanggalLahir),
                    if (role == 'pembeli' || role == 'penitip')
                      _buildInfoRow(Icons.star, 'Poin', points),
                    _buildInfoRow(Icons.money, 'Saldo', ' $formattedSaldo'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // TOMBOL LOGOUT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 188, 99, 142),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 204, 100, 135)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey)),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await AuthService.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const ReUseMartApp()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Iya'),
            ),
          ],
        );
      },
    );
  }
}
