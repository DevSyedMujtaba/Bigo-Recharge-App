import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CardFieldTestScreen extends StatefulWidget {
  const CardFieldTestScreen({Key? key}) : super(key: key);

  @override
  State<CardFieldTestScreen> createState() => _CardFieldTestScreenState();
}

class _CardFieldTestScreenState extends State<CardFieldTestScreen> {
  CardFieldInputDetails? _cardDetails;

  @override
  Widget build(BuildContext context) {
    print('Building CardFieldTestScreen');
    return Scaffold(
      appBar: AppBar(title: const Text('CardField Test')),
      body: Center(
        child: SizedBox(
          width: 350,
          height: 80,
          child: CardField(
            onCardChanged: (card) {
              print('CardField changed: card details updated');
              setState(() {
                _cardDetails = card;
              });
            },
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
