import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:p3l_reusemart/constants/api.dart';
import 'package:p3l_reusemart/screens/beranda.dart';
import '../models/user_model.dart';
import '../utils/shared_prefs.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;



 class ProfilKurir extends StatefulWidget {
  const ProfilKurir({super.key});

  @override
  State<ProfilKurir> createState() => _ProfilKurirState();
}

class _ProfilKurirState extends State<ProfilKurir> {
  User? user;
  String role = '';
  String kodeJabatan = '-';
  String tanggalLahir = '-';
  String points = '-';
  double saldo = 0;
  double totalKomisi = 0;
  int jumlahKomisi = 0;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final u = SharedPrefsUtil.getUser();
    if (u == null) return;

    final r = u.role ?? '';
    setState(() {
      user = u;
      role = r;
      kodeJabatan = u.originalData['kode_jabatan'] ?? '-';
      tanggalLahir = u.originalData['tanggal_lahir'] ?? '-';
      points = u.points?.toString() ?? '-';
      saldo = u.balance ?? 0;
    });
    print(user!.id);
    print(role);
    if (r == 'hunter') {
      await fetchKomisi(u.originalData['id_pegawai']);
    }
  }

  Future<void> fetchKomisi(String id) async {
    final res = await http.get(Uri.parse('${Api.historyKomisi}/$id'));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        totalKomisi = (data['total_komisi'] ?? 0).toDouble();
        jumlahKomisi = data['komisi']?.length ?? 0;
        saldo = totalKomisi;
      });
    }
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE91E63), Color.fromARGB(255, 169, 14, 79)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: const Color.fromARGB(255, 117, 46, 81),
                      child: Text(
                        user!.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    (role == 'hunter' || role == 'kurir')
                        ? '$kodeJabatan | ${role.toUpperCase()}'
                        : role.toUpperCase(),
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // KARTU INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
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
                      _buildInfoRow(Icons.email, 'Email', user!.email),
                      _buildInfoRow(Icons.phone, 'Telepon', user!.phone),
                      if (role == 'hunter' || role == 'kurir')
                        _buildInfoRow(
                          Icons.cake,
                          'Tanggal Lahir',
                          tanggalLahir,
                        ),
                      if (role == 'pembeli' || role == 'penitip')
                        _buildInfoRow(Icons.star, 'Poin', points),
                      if(role != 'pembeli' && role != 'kurir')
                        _buildInfoRow(
                        Icons.account_balance_wallet,
                        'Saldo',
                        saldo.toString(),
                      ),
                      if(role == 'hunter')
                        _buildInfoRow(
                          Icons.file_open,
                          'Jumlah Komisi',
                          jumlahKomisi.toString(),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _confirmLogout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 202, 46, 98),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFFBC638E)),
      title: Text(label, style: const TextStyle(color: Colors.grey)),
      subtitle: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {//perlu mengdelete akses fcm_token di database 
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
