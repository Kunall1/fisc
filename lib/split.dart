import 'package:flutter/material.dart';

class SplitPage extends StatefulWidget {
  final SplitTransaction splitTransaction;

  const SplitPage({Key? key, required this.splitTransaction}) : super(key: key);

  @override
  _SplitPageState createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Split Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${widget.splitTransaction.description}'),
            SizedBox(height: 10),
            Text(
                'Amount: \$${widget.splitTransaction.amount.toStringAsFixed(2)}'),
            SizedBox(height: 10),
            Text('Payer: ${widget.splitTransaction.payer}'),
            SizedBox(height: 10),
            Text(
                'Participants: ${widget.splitTransaction.participants.join(", ")}'),
          ],
        ),
      ),
    );
  }
}

class SplitTransaction {
  final String description;
  final double amount;
  final String payer;
  final List<String> participants;

  SplitTransaction({
    required this.description,
    required this.amount,
    required this.payer,
    required this.participants,
  });
}