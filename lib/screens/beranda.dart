import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/informasi_umum.dart';
import '../utils/shared_prefs.dart';
import '../models/PenitipRating.dart';
import '../constants/api.dart';

void main() {
  runApp(const ReUseMartApp());
}

class ReUseMartApp extends StatelessWidget {
  const ReUseMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReUseMart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}

class PenitipRating {
  final String name;
  final double averageRating;
  final int totalRatings;

  PenitipRating({
    required this.name,
    required this.averageRating,
    required this.totalRatings,
  });

  factory PenitipRating.fromJson(Map<String, dynamic> json) {
    return PenitipRating(
      name: json['nama_penitip'] ?? '',
      averageRating:
          (json['average_rating'] is int
              ? json['average_rating'].toDouble()
              : json['average_rating']) ??
          0.0,
      totalRatings: json['total_ratings'] ?? 0,
    );
  }
}

Future<List<PenitipRating>> fetchPenitipRating() async {
  try {
    final response = await http
        .get(Uri.parse(Api.rating))
        .timeout(const Duration(seconds: 10));
    print('HTTP Status: ${response.statusCode}');
    print('Raw Response: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      print('Parsed JSON: $jsonResponse');

      if (!jsonResponse['success']) {
        throw Exception(jsonResponse['message'] ?? 'Failed to load penitips');
      }

      final List<dynamic> data = jsonResponse['data'] ?? [];
      print('Data List: $data');

      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => PenitipRating.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load penitip rating: ${response.statusCode}');
    }
  } catch (e) {
    print('Fetch Error: $e');
    throw Exception('Network error: $e');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _imageController = PageController();
  final PageController _penitipController = PageController();

  Timer? _imageTimer;
  Timer? _penitipTimer;

  final List<String> highlightImages = [
    'lib/assets/konten2.png',
    'lib/assets/konten1.png',
    'lib/assets/konten3.png',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _imageTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (_imageController.hasClients) {
          int nextPage = (_imageController.page?.toInt() ?? 0) + 1;
          if (nextPage >= highlightImages.length) {
            nextPage = 0;
          }
          _imageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      });

      _penitipTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (_penitipController.hasClients) {
          int nextPage = (_penitipController.page?.toInt() ?? 0) + 1;
          if (nextPage >= 7) {
            // Asumsi maksimal 7 penitip dari API
            nextPage = 0;
          }
          _penitipController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _imageTimer?.cancel();
    _penitipTimer?.cancel();
    _imageController.dispose();
    _penitipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = SharedPrefsUtil.getUser();
    final bool isLoggedIn = user != null;
    final String? role = user?.role;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {}); // Refresh UI
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
            Image.asset('lib/assets/header.png'),
            const SizedBox(height: 16),
            if (isLoggedIn)
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    "Cari Semua di ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "ReUseMart",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [Colors.pink, Colors.black],
                        ).createShader(const Rect.fromLTWH(0, 0, 100, 20)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _imageController,
                itemCount: highlightImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(highlightImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SmoothPageIndicator(
              controller: _imageController,
              count: highlightImages.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.pink,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Text(
                    "Top Rated Penitip",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: FutureBuilder<List<PenitipRating>>(
                future: fetchPenitipRating(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No top penitips available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  final penitips = snapshot.data!;
                  return PageView.builder(
                    controller: _penitipController,
                    itemCount: penitips.length,
                    itemBuilder: (context, index) {
                      final penitip = penitips[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              penitip.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < penitip.averageRating.round()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              }),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${penitip.averageRating.toStringAsFixed(1)} (${penitip.totalRatings} rating${penitip.totalRatings == 1 ? '' : 's'})",
                            ),
                            const SizedBox(height: 6),
                            const Chip(
                              label: Text(
                                "Top Seller",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<PenitipRating>>(
              future: fetchPenitipRating(),
              builder: (context, snapshot) {
                return SmoothPageIndicator(
                  controller: _penitipController,
                  count: snapshot.hasData ? snapshot.data!.length : 0,
                  effect: const WormEffect(dotHeight: 8, dotWidth: 8),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
