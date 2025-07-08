import 'package:flutter/material.dart';
import '../../widgets/diamond_card.dart';
import '../../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/recharge_bottom_sheet.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _diamondsFuture;
  List<String> _carouselImages = [];
  int _currentPage = 0;
  late final PageController _pageController;
  Timer? _carouselTimer;
  bool _carouselLoading = true;
  String? _carouselError;

  @override
  void initState() {
    super.initState();
    print('HomeScreen: initState called');
    _diamondsFuture = AuthService().fetchDiamonds();
    _pageController = PageController();
    _fetchCarouselImages();
    _startAutoScroll();
  }

  Future<void> _fetchCarouselImages() async {
    if (!mounted) return;
    setState(() {
      _carouselLoading = true;
      _carouselError = null;
    });
    try {
      final baseUrl = dotenv.env['BACKEND_API_BASE_URL'];
      print(
        'Carousel: baseUrl = '
                '[33m'
                '[1m'
                '[4m'
                '[0m' +
            (baseUrl ?? 'NULL'),
      );
      if (baseUrl == null || baseUrl.isEmpty) {
        if (!mounted) return;
        setState(() {
          _carouselError = 'App not initialized. Please restart.';
          _carouselLoading = false;
        });
        print('Carousel: baseUrl is null or empty');
        return;
      }
      final url = Uri.parse('$baseUrl/carousal-images');
      print('Carousel: Fetching from URL: $url');
      final response = await http.get(url);
      print('Carousel: Response status: ${response.statusCode}');
      print('Carousel: Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          // Sort by 'order' if present
          data.sort((a, b) => (a['order'] ?? 0).compareTo(b['order'] ?? 0));
          if (!mounted) return;
          setState(() {
            _carouselImages = data
                .map<String>((img) => img['imageData'] as String)
                .toList();
            _carouselLoading = false;
          });
          print('Carousel: Loaded ${_carouselImages.length} images');
        } else {
          if (!mounted) return;
          setState(() {
            _carouselError = 'Invalid carousel data.';
            _carouselLoading = false;
          });
          print('Carousel: Invalid data format');
        }
      } else {
        if (!mounted) return;
        setState(() {
          _carouselError = 'Failed to fetch carousel images.';
          _carouselLoading = false;
        });
        print('Carousel: Failed to fetch, status: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _carouselError = 'Error: $e';
        _carouselLoading = false;
      });
      print('Carousel: Exception: $e');
    }
  }

  void _startAutoScroll() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      if (_pageController.hasClients && _carouselImages.isNotEmpty) {
        int nextPage = (_currentPage + 1) % _carouselImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF18192A),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: 8,
              ),
              child: Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  final user = auth.user;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Welcome ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            user?.name ?? 'Guest',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFFEC4899),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: _carouselLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _carouselError != null
                      ? Center(
                          child: Text(
                            _carouselError!,
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        )
                      : _carouselImages.isEmpty
                      ? const Center(
                          child: Text(
                            'No banners found',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: _carouselImages.length,
                              onPageChanged: (index) {
                                if (!mounted) return;
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                final imageData = _carouselImages[index];
                                if (imageData.startsWith('data:image')) {
                                  try {
                                    final base64Str = imageData.split(',').last;
                                    return Image.memory(
                                      base64Decode(base64Str),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    );
                                  } catch (_) {
                                    return Container(color: Colors.grey);
                                  }
                                } else {
                                  return Container(color: Colors.grey);
                                }
                              },
                            ),
                            Positioned(
                              bottom: 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _carouselImages.length,
                                  (index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentPage == index
                                            ? Colors.white
                                            : Colors.white38,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _diamondsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFEC4899),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Failed to load diamonds',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No diamonds found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  final diamonds = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: diamonds.length,
                    itemBuilder: (context, index) {
                      final item = diamonds[index];
                      return DiamondCard(
                        name: item['name'] ?? '',
                        count: item['diamondAmount'] ?? 0,
                        price: (item['price'] ?? 0).toDouble(),
                        oldPrice: (item['originalPrice'] ?? item['price'] ?? 0)
                            .toDouble(),
                        discount: (item['discountPercentage'] ?? 0).toInt(),
                        imageBase64: item['image'],
                        onTap: () => showRechargeBottomSheet(
                          context,
                          name: item['name'] ?? '',
                          count: item['diamondAmount'] ?? 0,
                          price: (item['price'] ?? 0).toDouble(),
                          oldPrice:
                              (item['originalPrice'] ?? item['price'] ?? 0)
                                  .toDouble(),
                          discount: (item['discountPercentage'] ?? 0).toInt(),
                          productId: item['id'] ?? '',
                          imageBase64: item['image'],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showRechargeBottomSheet(
  BuildContext context, {
  required String name,
  required int count,
  required double price,
  required double oldPrice,
  required int discount,
  required String productId,
  String? imageBase64,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        child: RechargeBottomSheet(
          name: name,
          count: count,
          price: price,
          oldPrice: oldPrice,
          discount: discount,
          productId: productId,
          imageBase64: imageBase64,
        ),
      );
    },
  );
}
