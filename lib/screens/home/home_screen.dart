import 'package:flutter/material.dart';
import '../../widgets/diamond_card.dart';
import '../../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/recharge_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _diamondsFuture;

  @override
  void initState() {
    super.initState();
    _diamondsFuture = AuthService().fetchDiamonds();
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                            'Hello, Welcome 👋',
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
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          user?.imageUrl ?? 'https://randomuser.me/api/portraits/men/1.jpg',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _diamondsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF8F5CF7)));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load diamonds', style: TextStyle(color: Colors.white)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No diamonds found', style: TextStyle(color: Colors.white)));
                  }
                  final diamonds = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        oldPrice: (item['originalPrice'] ?? item['price'] ?? 0).toDouble(),
                        discount: (item['discountPercentage'] ?? 0).toInt(),
                        imageBase64: item['image'],
                        onTap: () => showRechargeBottomSheet(context,
                          name: item['name'] ?? '',
                          count: item['diamondAmount'] ?? 0,
                          price: (item['price'] ?? 0).toDouble(),
                          oldPrice: (item['originalPrice'] ?? item['price'] ?? 0).toDouble(),
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

void showRechargeBottomSheet(BuildContext context, {
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