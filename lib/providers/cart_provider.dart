import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price * item.quantity);

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart');
    if (cartString != null) {
      final List decoded = jsonDecode(cartString);
      _items = decoded.map((e) => CartItem.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = jsonEncode(_items.map((e) => e.toJson()).toList());
    await prefs.setString('cart', cartString);
  }

  void addToCart(CartItem item) {
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + item.quantity);
    } else {
      _items.add(item);
    }
    saveCart();
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    final index = _items.indexWhere((e) => e.id == id);
    if (index >= 0 && quantity > 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      saveCart();
      notifyListeners();
    }
  }

  void removeFromCart(String id) {
    _items.removeWhere((e) => e.id == id);
    saveCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    saveCart();
    notifyListeners();
  }
} 