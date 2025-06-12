import 'package:flutter/material.dart';
import 'package:p3l_reusemart/constants/api.dart';
import 'package:p3l_reusemart/models/order_models.dart';
import 'package:p3l_reusemart/screens/history_komisi_page.dart';
import 'package:p3l_reusemart/screens/merchandise.dart';
import 'package:p3l_reusemart/screens/orders_page.dart';
import 'package:p3l_reusemart/screens/penitip/riwayat_penitipan.dart';
import 'package:p3l_reusemart/services/barang_service.dart';
import 'package:p3l_reusemart/utils/garansi_utils.dart';

import '../models/user_model.dart';
import '../utils/shared_prefs.dart';
import 'history_page.dart';
import 'profil.dart';
import 'pembeli/riwayat_pembelian.dart';
import '../screens/beranda.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;
  String? _role;
  int _selectedIndex = 0;
  
  


  List<String> get _titles {
    if (_role == 'kurir') {
      return [
        'Home',
        'Jadwal Pengiriman',
        'Riwayat Pengiriman',
        'Profil Kurir',
      ];
    }
    if (_role == 'penitip') {
      return ['Home', 'Riwayat Transaksi', 'Profil Penitip'];

    } else if(_role == 'hunter'){
      return [
        'Home', 
        'Riwayat Komisi', 
        'Profil',
        ];
    }else if(_role == 'pembeli'){
      return [
        'Home', 
        'Merchandise', 
        'Profil',
        ];
    } else {
      return ['Home', 'Riwayat Pembelian', 'Profil Pembeli'];
    }
  }

  List<Widget> get _pages {
    if (_role == 'kurir') {
      return [
        const ReUseMartApp(),
        const OrdersPage(),
        const HistoryPage(),
        const ProfilKurir(),
      ];
    } else if (_role == 'penitip') {
      return [
        const ReUseMartApp(),
        const RiwayatTransaksiPage(),
        const ProfilKurir(),
    } else if(_role == 'hunter') {
      return [
        const HomeContent(), 
        const HistoryKomisiPage(),
        const ProfilKurir()
        ];
    } else if(_role == 'pembeli') {
      return [
        const HomeContent(), 
        const MerchandisePage(), 
        const ProfilKurir()
      ];
    } else {
      return [
        const ReUseMartApp(),
        const HistoryTransaksiPage(),
        const ProfilKurir(),
      ];
    }
  }

  List<BottomNavigationBarItem> get _navigationItems {
    if (_role == 'kurir') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          activeIcon: Icon(Icons.history_edu),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ];
    } else if(_role == 'hunter'){
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          activeIcon: Icon(Icons.history_edu),
          label: 'Riwayat Komisi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ];
    } else if(_role=='pembeli') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Merchandise',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          activeIcon: Icon(Icons.history),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _user = SharedPrefsUtil.getUser();
      _role = SharedPrefsUtil.getRole();
    });
  }

  


  Future<void> _onItemTapped(int index) async {
  if ((_role == 'kurir' && index == 3) || (_role != 'kurir' && index == 1)) {
    if (!SharedPrefsUtil.isLoggedIn()) {
      final result = await Navigator.pushNamed(context, '/login');
      if (result == true) {
        _loadUserData();
        setState(() {
          _selectedIndex = index;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login berhasil!')),
        );
      }
      return;
    }
  }

  setState(() {
    _selectedIndex = index;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: const Color(0xFFE9C8CE),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE9C8CE),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: const Color(0xFFE9C8CE),
            selectedItemColor: const Color.fromARGB(255, 161, 50, 87),
            unselectedItemColor: const Color.fromARGB(255, 210, 122, 151),
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: _navigationItems,
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late Future<List<Barang>> barangFuture;
  List<Barang> _allBarang = [];
  List<Barang> _filteredBarang = [];
  TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    barangFuture = BarangService.fetchBarangTersedia();
    _searchController.addListener(_onSearchChanged);
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBarang = _allBarang
          .where((barang) => barang.namaBarang.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = SharedPrefsUtil.getUser();
    final role = SharedPrefsUtil.getRole();

    // if (user == null) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FutureBuilder Gambar Barang
           
            Expanded(
              child: FutureBuilder<List<Barang>>(
              future: barangFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada barang tersedia'));
                }

                _allBarang = snapshot.data!;
                if (_filteredBarang.isEmpty && _searchController.text.isEmpty) {
                  _filteredBarang = _allBarang;
                }

                return Column(
                  children: [
                    if (user != null) ...[
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ${user.name}!',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Role: ${role?.toUpperCase() ?? "User"}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if(role=='penitip' || role=='pembeli')...[
                                _buildInfoItem('Points', '${user.points}'),
                                _buildInfoItem('Balance', 'Rp ${user.balance}'),
                                if (role == 'penitip')
                                  _buildInfoItem('Top Seller', user.isTopSeller ? 'Yes' : 'No'),
                              ]
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      // _buildInfoItem('Email', user.email),
                      // _buildInfoItem('Phone', user.phone),
                      
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Cari barang...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _filteredBarang.length,
                        itemBuilder: (context, index) {
                          final barang = _filteredBarang[index];
                          final gambar = barang.fotoProduk.isNotEmpty ? barang.fotoProduk[0] : '';
                          final warna = getWarrantyColor(barang.batasGaransi);
                          final label = getWarrantyStatus(barang.batasGaransi);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailBarangScreen(barang: barang),
                                ),
                              );
                            },
                            child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        child: Image.network(
                                          '${Api.baseUrlnon}/storage/$gambar',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (context, _, __) =>
                                              const Icon(Icons.broken_image, size: 80),
                                        ),
                                      ),
                                      if (barang.batasGaransi != null)
                                        Positioned(
                                          bottom:8,
                                          left: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: getWarrantyColor(barang.batasGaransi),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'Garansi',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    barang.namaBarang,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),

            ),
          ],
        ),
      ),
    );
  }



  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBarangScreen extends StatelessWidget {
  final Barang barang;
  const DetailBarangScreen({super.key, required this.barang});

  @override
  Widget build(BuildContext context) {
    final fotoList = barang.fotoProduk; 
    final warna = getWarrantyColor(barang.batasGaransi);
    final label = getWarrantyStatus(barang.batasGaransi);

    return Scaffold(
      appBar: AppBar(
        title: Text(barang.namaBarang),
        backgroundColor: const Color(0xFFE9C8CE),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            child: PageView.builder(
              itemCount: fotoList.length,
              itemBuilder: (context, index) {
                return Image.network(
                  '${Api.baseUrlnon}/storage/${fotoList[index]}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, _, __) => const Icon(Icons.broken_image, size: 100),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  barang.namaBarang,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${barang.harga}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
               
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: warna,
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Text('Status Garansi: '),
                    Text('$label',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ), 
                const SizedBox(height: 16),
                Text(barang.deskripsi),
                const SizedBox(height: 16),
              ],
            ),
          )
        ],
      ),
    );
  }
}
