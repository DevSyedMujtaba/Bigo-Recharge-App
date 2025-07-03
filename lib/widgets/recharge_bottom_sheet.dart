import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/package_service.dart';
import '../providers/auth_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../screens/home/cart_screen.dart';

class RechargeBottomSheet extends StatefulWidget {
  final String name;
  final int count;
  final double price;
  final double oldPrice;
  final int discount;
  final String productId;
  final String? imageBase64;

  const RechargeBottomSheet({
    super.key,
    required this.name,
    required this.count,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.productId,
    this.imageBase64,
  });

  @override
  State<RechargeBottomSheet> createState() => _RechargeBottomSheetState();
}

class _RechargeBottomSheetState extends State<RechargeBottomSheet> {
  final TextEditingController _bigoIdController = TextEditingController();
  final TextEditingController _promoController = TextEditingController();
  int _quantity = 1;
  double? _total;
  bool _isLoading = false;
  String? _errorMsg;
  String? _promoMsg;
  String? _bigoIdError;
  double? _discountPercent;
  double? _basePrice;

  @override
  void initState() {
    super.initState();
    _basePrice = widget.price;
  }

  @override
  void dispose() {
    _bigoIdController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _applyPromo() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
      _promoMsg = null;
    });
    final code = _promoController.text.trim();
    final url = Uri.parse(
      'https://bigo-recharge-backend.onrender.com/api/promo-codes/validate?code=$code',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : null;
        final discountPercent = (data != null && data['discount'] != null)
            ? (data['discount'] as num).toDouble()
            : 0.0;
        if (discountPercent > 0) {
          setState(() {
            _discountPercent = discountPercent;
            _promoMsg = 'Promo code applied!';
            _errorMsg = null;
          });
        } else {
          setState(() {
            _discountPercent = null;
            _promoMsg = null;
            _errorMsg = 'Invalid promo code.';
          });
        }
      } else {
        setState(() {
          _discountPercent = null;
          _promoMsg = null;
          _errorMsg = 'Invalid promo code.';
        });
      }
    } catch (e) {
      setState(() {
        _discountPercent = null;
        _promoMsg = null;
        _errorMsg = 'Something went wrong. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double get _calculatedTotal {
    final base = _basePrice ?? widget.price;
    double total = base * _quantity;
    if (_discountPercent != null && _discountPercent! > 0) {
      final discountAmount = total * (_discountPercent! / 100);
      total = total - discountAmount;
    }
    return total;
  }

  void _onBuyNow() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      _bigoIdError = null;
    });
    if (_bigoIdController.text.trim().isEmpty) {
      setState(() {
        _bigoIdError = 'BIGO ID is required.';
      });
      return;
    }
    if (!authProvider.isLoggedIn) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/login');
      return;
    }
    // TODO: Navigate to checkout screen with all required data
    // Navigator.pushNamed(context, '/checkout', arguments: {...});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight * 0.7;
        return Container(
          constraints: BoxConstraints(maxHeight: maxHeight, minHeight: 0),
          decoration: const BoxDecoration(
            color: Color(0xFF23283A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Recharge account',
                      style: TextStyle(
                        color: Color(0xFF8F5CF7),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'BIGO ID *',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _bigoIdController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2D3246),
                      hintText: 'Enter BIGO ID',
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      errorText: _bigoIdError,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Promo Code (optional)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _promoController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2D3246),
                            hintText: 'Enter promo code (e.g., SAVE10)',
                            hintStyle: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8F5CF7),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isLoading ? null : _applyPromo,
                        child: _isLoading
                            ? SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Apply',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                  if (_promoMsg != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _promoMsg!,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  if (_errorMsg != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _errorMsg!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    'Quantity *',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D3246),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 16,
                          ),
                          onPressed: _quantity > 1
                              ? () => setState(() {
                                  _quantity--;
                                  _total = widget.price * _quantity;
                                })
                              : null,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D3246),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D3246),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                          onPressed: () => setState(() {
                            _quantity++;
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '\$${(_basePrice! * _quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (_promoMsg != null &&
                      _discountPercent != null &&
                      _discountPercent! > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 6),
                      child: Text(
                        'Discounted: \$${(_basePrice! * _quantity * (1 - _discountPercent! / 100)).toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF23283A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF8F5CF7),
                          size: 13,
                        ),
                        SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            'This platform does not swipe orders, no commission, or beware of fraud. Please do not fill in the recharge account of others to prevent being deceived.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8F5CF7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _bigoIdError = null;
                              });
                              if (_bigoIdController.text.trim().isEmpty) {
                                setState(() {
                                  _bigoIdError = 'BIGO ID is required.';
                                });
                                return;
                              }
                              final double amountToPay =
                                  (_discountPercent != null &&
                                      _discountPercent! > 0)
                                  ? (_basePrice! *
                                        _quantity *
                                        (1 - _discountPercent! / 100))
                                  : (_basePrice! * _quantity);
                              print(
                                'DEBUG: Amount to pay (sent to Stripe): $amountToPay',
                              );
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => PaymentBottomSheet(
                                  bigoId: _bigoIdController.text,
                                  discountedPrice:
                                      (_discountPercent != null &&
                                          _discountPercent! > 0)
                                      ? (_basePrice! *
                                            _quantity *
                                            (1 - _discountPercent! / 100))
                                      : null,
                                  promoCode: _promoController.text.isNotEmpty
                                      ? _promoController.text
                                      : null,
                                  promoCodeApplied:
                                      _promoMsg != null &&
                                      _discountPercent != null &&
                                      _discountPercent! > 0,
                                  amount: amountToPay,
                                ),
                              );
                            },
                      child: _isLoading
                          ? SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'BUY NOW',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                                letterSpacing: 1.1,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
