import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'packages_tab.dart';
import 'cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:diamonds_recharge/providers/cart_provider.dart';
import 'settings_tab.dart';

class HomeRootScreen extends StatefulWidget {
  const HomeRootScreen({super.key});

  @override
  State<HomeRootScreen> createState() => HomeRootScreenState();
}

class HomeRootScreenState extends State<HomeRootScreen> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PackagesTab(),
    CartScreen(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartCount = Provider.of<CartProvider>(context).totalItems;
    return Scaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF18192A),
        selectedItemColor: const Color(0xFFEC4899),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Packages',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
                if (cartCount > 0)
                  Positioned(
                    right: -6,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Color(0xFFEC4899),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
