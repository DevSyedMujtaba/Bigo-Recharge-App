import 'package:flutter/material.dart';
import 'dart:convert';

class DiamondCard extends StatelessWidget {
  final String name;
  final int count;
  final double price;
  final double oldPrice;
  final int discount;
  final String? imageBase64;
  final VoidCallback? onTap;

  const DiamondCard({
    super.key,
    required this.name,
    required this.count,
    required this.price,
    required this.oldPrice,
    required this.discount,
    this.imageBase64,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget diamondImage = Icon(Icons.diamond, color: Color(0xFF6EC6FF), size: 36);
    if (imageBase64 != null && imageBase64!.startsWith('data:image')) {
      try {
        final base64Str = imageBase64!.split(',').last;
        diamondImage = Image.memory(
          base64Decode(base64Str),
          width: 36,
          height: 36,
          fit: BoxFit.contain,
        );
      } catch (_) {}
    }
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF23243A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$count Diamonds',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4),
                    diamondImage,
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (oldPrice > price)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Thinner white line for strikethrough
                            Container(
                              height: 1,
                              width: 60,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Text(
                                '\$${oldPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.transparent, // Hide default line
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (discount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '-$discount%',
                    style: const TextStyle(
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
    );
  }
} 