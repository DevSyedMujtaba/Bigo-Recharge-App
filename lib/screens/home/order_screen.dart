import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String? _error;
  List<dynamic> _orders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      final token = authProvider.token;
      if (user == null || token == null) {
        setState(() {
          _error = 'User not logged in.';
          _isLoading = false;
        });
        return;
      }
      //final baseUrl = dotenv.env['BACKEND_API_BASE_URL'] ?? '';
      final baseUrl = "https://www.diamondstopup.com/api/api";
      final url = Uri.parse('$baseUrl/orders/user/${user.id}');
      print('Token: $token');
      print('User ID: ${user.id}');
      print('URL: $url');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('Status: [${response.statusCode}]');
      print('Body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _orders = data is List ? data : (data['orders'] ?? []);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to fetch orders.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFF18192A);
    final Color cardColor = const Color(0xFF23243A);
    final Color accent = const Color(0xFFEC4899);
    final Color green = Colors.greenAccent;
    final Color red = Colors.redAccent;
    final Color yellow = Colors.amberAccent;
    final Color white = Colors.white;
    final Color faint = Colors.white70;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'My Orders',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            isScrollable: false,
            indicatorColor: accent,
            labelColor: accent,
            unselectedLabelColor: faint,
            labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
            tabs: const [
              Tab(child: Text('Pending', style: TextStyle(fontSize: 13))),
              Tab(child: Text('Completed', style: TextStyle(fontSize: 13))),
              Tab(child: Text('Refunded', style: TextStyle(fontSize: 13))),
              Tab(child: Text('Cancelled', style: TextStyle(fontSize: 13))),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: TextStyle(color: Colors.redAccent)),
            )
          : _orders.isEmpty
          ? const Center(
              child: Text(
                'No orders found',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _OrderList(
                  orders: _orders
                      .where((o) => o['status'] == 'Pending')
                      .toList(),
                  cardColor: cardColor,
                  accent: accent,
                  statusColor: yellow,
                  statusText: 'Pending',
                ),
                _OrderList(
                  orders: _orders
                      .where((o) => o['status'] == 'Completed')
                      .toList(),
                  cardColor: cardColor,
                  accent: accent,
                  statusColor: green,
                  statusText: 'Delivered',
                ),
                _OrderList(
                  orders: _orders
                      .where((o) => o['status'] == 'Refunded')
                      .toList(),
                  cardColor: cardColor,
                  accent: accent,
                  statusColor: accent,
                  statusText: 'Refunded',
                ),
                _OrderList(
                  orders: _orders
                      .where((o) => o['status'] == 'Cancelled')
                      .toList(),
                  cardColor: cardColor,
                  accent: accent,
                  statusColor: red,
                  statusText: 'Cancelled',
                ),
              ],
            ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<dynamic> orders;
  final Color cardColor;
  final Color accent;
  final Color statusColor;
  final String statusText;

  const _OrderList({
    required this.orders,
    required this.cardColor,
    required this.accent,
    required this.statusColor,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Text('No orders found', style: TextStyle(color: Colors.white70)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final orderId = order['id'] ?? '';
        final orderDate = order['orderDate'] ?? order['createdAt'] ?? '';
        final status = order['status'] ?? '';
        final totalAmount = order['totalAmount'] ?? order['total'] ?? 0.0;
        final userName = order['userName'] ?? order['user']?['name'] ?? '';
        final userEmail = order['userEmail'] ?? order['user']?['email'] ?? '';
        final products = order['products'] as List<dynamic>? ?? [];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Order number, date, status, total
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.inventory_2, color: accent, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${orderId.toString().substring(0, 8)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatOrderDate(orderDate),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                'Status: ',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 11,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total: ',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '\$${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFFE754A6), // Pink accent
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Items section
                const Text(
                  'Items:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                ...products.map((product) {
                  final productName = product['name'] ?? '';
                  final quantity = product['quantity'] ?? 1;
                  final unitPrice = product['price'] ?? 0.0;
                  final diamondAmount = product['diamondAmount'] ?? '';
                  final image = product['image'] ?? '';
                  Widget productImageWidget;
                  if (image is String && image.startsWith('data:image')) {
                    try {
                      final base64Str = image.split(',').last;
                      productImageWidget = Image.memory(
                        base64Decode(base64Str),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      );
                    } catch (_) {
                      productImageWidget = Icon(
                        Icons.diamond,
                        color: accent,
                        size: 36,
                      );
                    }
                  } else {
                    productImageWidget = Icon(
                      Icons.diamond,
                      color: accent,
                      size: 36,
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: productImageWidget,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$productName',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Diamonds: $diamondAmount',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                'Quantity: $quantity',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                'Unit Price: \$${unitPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(
                            '\$${unitPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                // Footer
                Text(
                  'Order placed by: $userName ($userEmail)',
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 11),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatOrderDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return 'Placed on: ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }
}
