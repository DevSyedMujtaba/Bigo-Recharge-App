import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    // Add debug print for PaymentBottomSheet entry point
    // (Find the showModalBottomSheet for PaymentBottomSheet and add this print)
    // Example:
    // print('DEBUG: CartScreen opening PaymentBottomSheet with amount: ...');
    return Scaffold(
      backgroundColor: const Color(0xFF18192A),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 24,
                right: 24,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Total Items ${cart.totalItems}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cart.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF23243A),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: item.image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    item.image!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.widgets,
                                  color: Colors.white38,
                                  size: 32,
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.white70,
                              ),
                              onPressed: item.quantity > 1
                                  ? () => cart.updateQuantity(
                                      item.id,
                                      item.quantity - 1,
                                    )
                                  : null,
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.white70,
                              ),
                              onPressed: () => cart.updateQuantity(
                                item.id,
                                item.quantity + 1,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => cart.removeFromCart(item.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.white24, thickness: 1),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${cart.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8F5CF7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        final isLoggedIn = Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).isLoggedIn;
                        if (isLoggedIn) {
                          final cart = Provider.of<CartProvider>(
                            context,
                            listen: false,
                          );
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => PaymentBottomSheet(
                              bigoId: null,
                              discountedPrice: null,
                              promoCode: null,
                              promoCodeApplied: false,
                              amount: cart.totalPrice,
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Checkout ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentBottomSheet extends StatefulWidget {
  final String? bigoId;
  final double? discountedPrice;
  final String? promoCode;
  final bool promoCodeApplied;
  final double? amount;
  const PaymentBottomSheet({
    this.bigoId,
    this.discountedPrice,
    this.promoCode,
    this.promoCodeApplied = false,
    this.amount,
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentBottomSheet> createState() => PaymentBottomSheetState();
}

class PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _bigoIdController = TextEditingController();
  final TextEditingController _promoController = TextEditingController();
  bool _isApplyingPromo = false;
  bool _isLoading = false;
  String? _promoMsg;
  String? _promoError;
  double? _discountPercent;
  String? _bigoIdError;
  String? _cardError;
  CardFieldInputDetails? _cardDetails;
  double? _discountedTotalOverride;
  bool _promoCodeFieldDisabled = false;

  double get _cartTotal {
    if (widget.amount != null) {
      return widget.amount!;
    }
    final cart = Provider.of<CartProvider>(context, listen: false);
    return cart.totalPrice;
  }

  double get _discountedTotal {
    if (_discountedTotalOverride != null) {
      return _discountedTotalOverride!;
    }
    if (_discountPercent != null && _discountPercent! > 0) {
      return _cartTotal * (1 - _discountPercent! / 100);
    }
    return _cartTotal;
  }

  @override
  void initState() {
    super.initState();
    print(
      '===STRIPE_DEBUG=== PaymentBottomSheet initState - widget.amount:  ${widget.amount}',
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      _fullNameController.text = authProvider.user!.name;
      _emailController.text = authProvider.user!.email ?? '';
    }
    if (widget.bigoId != null && widget.bigoId!.isNotEmpty) {
      _bigoIdController.text = widget.bigoId!;
    }
    if (widget.promoCode != null && widget.promoCode!.isNotEmpty) {
      _promoController.text = widget.promoCode!;
    }
    if (widget.discountedPrice != null) {
      _discountedTotalOverride = widget.discountedPrice;
    }
    _promoCodeFieldDisabled = widget.promoCodeApplied;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _zipController.dispose();
    _bigoIdController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  Future<String?> createPaymentIntent({
    required int amount,
    String currency = 'usd',
  }) async {
    final url = Uri.parse(
      'https://bigo-recharge-backend.onrender.com/api/stripe/create-payment-intent',
    );
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount, 'currency': currency}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['clientSecret'] as String?;
      }
    } catch (e) {
      print('Error creating payment intent: $e');
    }
    return null;
  }

  Future<bool> payWithStripe(String clientSecret) async {
    try {
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              email: _emailController.text,
              name: _fullNameController.text,
            ),
          ),
        ),
      );
      return true;
    } on StripeException catch (e) {
      print('Stripe error: [31m${e.error.localizedMessage}[0m');
      return false;
    } catch (e) {
      print('Payment error: $e');
      return false;
    }
  }

  Future<void> _applyPromo() async {
    setState(() {
      _isApplyingPromo = true;
      _promoMsg = null;
      _promoError = null;
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
            _promoMsg = 'Promo code applied!';
            _promoError = null;
            _discountPercent = discountPercent;
          });
        } else {
          setState(() {
            _promoMsg = null;
            _promoError = 'Invalid promo code.';
            _discountPercent = null;
          });
        }
      } else {
        setState(() {
          _promoMsg = null;
          _promoError = 'Invalid promo code.';
          _discountPercent = null;
        });
      }
    } catch (e) {
      setState(() {
        _promoMsg = null;
        _promoError = 'Something went wrong. Please try again.';
        _discountPercent = null;
      });
    } finally {
      setState(() {
        _isApplyingPromo = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
      '===STRIPE_DEBUG=== PaymentBottomSheet build - widget.amount:  ${widget.amount}, _cartTotal:  ${_cartTotal}, _discountedTotal:  ${_discountedTotal}',
    );
    final Color bgColor = const Color(0xFF23243A);
    final Color accent = const Color(0xFF8F5CF7);
    final Color border = Colors.white24;
    final Color text = Colors.white;
    final Color textFaint = Colors.white70;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(
        minHeight: screenHeight * 0.60, // Responsive minimum height
        maxHeight: screenHeight * 0.95, // Responsive maximum height
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF23243A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Information',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name',
                        style: TextStyle(
                          color: textFaint,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 36,
                        child: TextField(
                          controller: _fullNameController,
                          style: TextStyle(color: text, fontSize: 13),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: bgColor,
                            hintText: 'Full Name',
                            hintStyle: TextStyle(
                              color: textFaint,
                              fontSize: 13,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: border),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: TextStyle(
                          color: textFaint,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 36,
                        child: TextField(
                          controller: _emailController,
                          style: TextStyle(color: text, fontSize: 13),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: bgColor,
                            hintText: 'Email Address',
                            hintStyle: TextStyle(
                              color: textFaint,
                              fontSize: 13,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: border),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Card Details',
              style: TextStyle(
                color: textFaint,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: 56,
              child: CardField(
                onCardChanged: (card) {
                  print('CardField changed: card details updated');
                  setState(() {
                    _cardDetails = card;
                    _cardError = null;
                  });
                },
                style: TextStyle(color: text, fontSize: 13),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: bgColor,
                  hintText: 'Card Number',
                  hintStyle: TextStyle(color: textFaint, fontSize: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: border),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            if (_cardError != null)
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 2, left: 2),
                child: Text(
                  _cardError!,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: TextField(
                      controller: _zipController,
                      style: TextStyle(color: text, fontSize: 13),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: bgColor,
                        hintText: 'ZIP',
                        hintStyle: TextStyle(color: textFaint, fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(color: border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(color: border),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Bigo ID',
              style: TextStyle(
                color: textFaint,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 36,
              child: TextField(
                controller: _bigoIdController,
                style: TextStyle(color: text, fontSize: 13),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: bgColor,
                  hintText: 'Enter your Bigo ID',
                  hintStyle: TextStyle(color: textFaint, fontSize: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: border),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: Colors.redAccent, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: Colors.redAccent, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  errorText: _bigoIdError,
                  errorStyle: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Promo Code',
              style: TextStyle(
                color: textFaint,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: TextField(
                      controller: _promoController,
                      enabled: !_promoCodeFieldDisabled,
                      style: TextStyle(color: text, fontSize: 13),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: bgColor,
                        hintText: 'Promo Code',
                        hintStyle: TextStyle(color: textFaint, fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(color: border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(color: border),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    onPressed: (_isApplyingPromo || _promoCodeFieldDisabled)
                        ? null
                        : _applyPromo,
                    child: _isApplyingPromo
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Apply',
                            style: TextStyle(color: Colors.white, fontSize: 13),
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
                  style: TextStyle(color: Colors.greenAccent, fontSize: 12),
                ),
              ),
            if (_promoError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _promoError!,
                  style: TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              'Total: \$${_cartTotal.toStringAsFixed(2)}',
              style: TextStyle(
                color: text,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            if (_discountPercent != null && _discountPercent! > 0)
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 6),
                child: Text(
                  'Discounted: \$${_discountedTotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isLoading
                    ? null
                    : () async {
                        print(
                          '===STRIPE_DEBUG=== Payment button pressed - widget.amount: ￿${widget.amount}, _cartTotal: ￿${_cartTotal}, _discountedTotal: ￿${_discountedTotal}',
                        );
                        setState(() {
                          _bigoIdError = null;
                          _cardError = null;
                          _isLoading = true;
                        });
                        if (_bigoIdController.text.trim().isEmpty) {
                          setState(() {
                            _bigoIdError = 'Bigo ID is required.';
                            _isLoading = false;
                          });
                          return;
                        }
                        if (_cardDetails == null || !_cardDetails!.complete) {
                          setState(() {
                            _cardError = 'Please enter complete card details.';
                            _isLoading = false;
                          });
                          return;
                        }
                        double amountToPay = _discountedTotal;
                        if (amountToPay <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Payment amount is missing or invalid.',
                              ),
                            ),
                          );
                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }
                        final amountInCents = (amountToPay * 100).toInt();
                        print(
                          '===STRIPE_DEBUG=== Amount sent to Stripe (in cents): $amountInCents',
                        );
                        final clientSecret = await createPaymentIntent(
                          amount: amountInCents,
                        );
                        if (clientSecret == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to initiate payment. Please try again.',
                              ),
                            ),
                          );
                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }
                        final success = await payWithStripe(clientSecret);
                        setState(() {
                          _isLoading = false;
                        });
                        if (success) {
                          Provider.of<CartProvider>(
                            context,
                            listen: false,
                          ).clearCart();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Payment successful!')),
                          );
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Payment failed. Please try again.',
                              ),
                            ),
                          );
                        }
                      },
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.lock, color: Colors.white, size: 18),
                label: const Text(
                  'Securely Place Order',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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

class _PaymentTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color accent;
  const _PaymentTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? accent.withOpacity(0.15) : Colors.transparent,
            border: Border.all(
              color: selected ? accent : Colors.white24,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? accent : Colors.white54, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? accent : Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
