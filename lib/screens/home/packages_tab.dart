import 'package:flutter/material.dart';
import '../../models/package.dart';
import '../../services/package_service.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';
import 'home_root_screen.dart';

class PackagesTab extends StatefulWidget {
  const PackagesTab({super.key});

  @override
  State<PackagesTab> createState() => _PackagesTabState();
}

class _PackagesTabState extends State<PackagesTab> {
  late Future<List<Package>> _packagesFuture;

  @override
  void initState() {
    super.initState();
    _packagesFuture = PackageService().fetchPackages();
  }

  void _goToCartTab() {
    // Find the nearest HomeRootScreen state and set the index to 2 (Cart tab)
    final homeRootState = context.findAncestorStateOfType<HomeRootScreenState>();
    if (homeRootState != null) {
      homeRootState.setState(() {
        homeRootState.selectedIndex = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18192A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Center(
                child: Text(
                  'Explore Our Packages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Package>>(
                future: _packagesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF8F5CF7)));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Failed to load packages',
                        style: TextStyle(color: Colors.red[300]),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No packages found', style: TextStyle(color: Colors.white)),
                    );
                  }
                  final packages = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12, top: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 18,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: packages.length,
                    itemBuilder: (context, index) {
                      final pkg = packages[index];
                      Widget? imageWidget;
                      if (pkg.image != null && pkg.image!.startsWith('data:image')) {
                        try {
                          final base64Str = pkg.image!.split(',').last;
                          imageWidget = Image.memory(
                            base64Decode(base64Str),
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          );
                        } catch (_) {}
                      }
                      return Material(
                        color: Colors.transparent,
                        elevation: 6,
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF18192A),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white24, width: 1.0),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (pkg.discountAmount > 0)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF8F5CF7),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Save \$${pkg.discountAmount.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (imageWidget != null) ...[
                                      const SizedBox(height: 2),
                                      imageWidget,
                                    ],
                                    const SizedBox(height: 2),
                                    Text(
                                      pkg.diamondAmount.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF8F5CF7),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'Diamonds',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF8F5CF7),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      pkg.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    if (pkg.description != null && pkg.description!.isNotEmpty)
                                      Text(
                                        pkg.description!,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '\$${pkg.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: 75,
                                      height: 32,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF8F5CF7),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.zero,
                                          elevation: 0,
                                        ),
                                        onPressed: () {
                                          Provider.of<CartProvider>(context, listen: false).addToCart(
                                            CartItem(
                                              id: pkg.id,
                                              name: pkg.name,
                                              image: null, // You can use pkg.image if it's a URL
                                              price: pkg.price,
                                              quantity: 1,
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('${pkg.name} added to cart!')),
                                          );
                                          //_goToCartTab();
                                        },
                                        child: const Text(
                                          'Add to Cart',
                                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
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