import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'screens/splash/splash_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  print('Initializing Stripe...');
  // print('Loaded Stripe key: ${dotenv.env['STRIPE_KEY'] ?? ''}');
  Stripe.publishableKey =
      'pk_test_51Rb6soPrqL3Cx7E1EANctkBEsubquBR7W911AcD6wO8zT3C2QqrxF0TUjZONqmZCgCFPQtZUqPNs3aoDwqEDHolK00tU2dMzIj';
  await Stripe.instance.applySettings();
  print('Stripe publishable key set and settings applied. Running app...');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BIGO Recharge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
       
      },
    );
  }
}

