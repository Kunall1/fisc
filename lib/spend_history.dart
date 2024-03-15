import 'dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SpendHistoryPage extends StatefulWidget {
  @override
  _SpendHistoryPageState createState() => _SpendHistoryPageState();
}

class _SpendHistoryPageState extends State<SpendHistoryPage> {
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  bool _sortByDateAscending = true;
  TextEditingController _amountController = TextEditingController();
  TransactionType _selectedTransactionType = TransactionType.credit;

  @override
  void initState() {
    super.initState();
    _fetchInitialTransactions();
  }

  Future<void> _fetchInitialTransactions() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('expenses')
            .doc(user.uid)
            .collection('transactions')
            .get();

        setState(() {
          _transactions = querySnapshot.docs
              .map((doc) => Transaction.fromFirestore(doc))
              .toList();
          _filteredTransactions.addAll(_transactions);
        });
      }
    } catch (e) {
      print('Error fetching initial transactions: $e');
    }
  }

  void _filterTransactions(TransactionType type) {
    setState(() {
      _filteredTransactions.clear();
      _filteredTransactions.addAll(
          _transactions.where((transaction) => transaction.type == type));
    });
  }

  void _sortTransactionsByDate() {
    setState(() {
      if (_sortByDateAscending) {
        _filteredTransactions.sort((a, b) => a.date.compareTo(b.date));
      } else {
        _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
      }
      _sortByDateAscending = !_sortByDateAscending;
    });
  }

  Future<void> _addExpenseManually(double amount, TransactionType type) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('expenses')
            .doc(user.uid)
            .collection('transactions')
            .add({
          'amount': amount,
          'type': type == TransactionType.credit ? 'credit' : 'debit',
          'date': DateTime.now(),
        });

        setState(() {
          _transactions.add(Transaction(
            amount: amount,
            type: type,
            date: DateTime.now(),
            category: TransactionCategory(
              icon: Icons.attach_money,
              name: "Manual",
            ),
          ));
          _filteredTransactions.add(Transaction(
            amount: amount,
            type: type,
            date: DateTime.now(),
            category: TransactionCategory(
              icon: Icons.attach_money,
              name: "Manual",
            ),
          ));
        });
      }
    } catch (e) {
      print('Error adding expense: $e');
    }
  }

  void _addExpenseManuallyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Manual Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              DropdownButtonFormField<TransactionType>(
                value: _selectedTransactionType,
                onChanged: (TransactionType? value) {
                  setState(() {
                    _selectedTransactionType = value!;
                  });
                },
                items: TransactionType.values.map((TransactionType type) {
                  return DropdownMenuItem<TransactionType>(
                    value: type,
                    child: Text(
                        type == TransactionType.credit ? 'Credit' : 'Debit'),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double amount = double.tryParse(_amountController.text) ?? 0;
                if (amount > 0) {
                  _addExpenseManually(amount, _selectedTransactionType);
                }
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalCredited = _transactions
        .where((transaction) => transaction.type == TransactionType.credit)
        .fold(0, (sum, transaction) => sum + transaction.amount);

    double totalDebited = _transactions
        .where((transaction) => transaction.type == TransactionType.debit)
        .fold(0, (sum, transaction) => sum + transaction.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Spend History'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: _sortTransactionsByDate,
          ),
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // Changed background color to light theme
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Total Credited: ₹${totalCredited.toStringAsFixed(2)}', // Replaced $ with ₹
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total Debited: ₹${totalDebited.toStringAsFixed(2)}', // Replaced $ with ₹
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _filterTransactions(TransactionType.credit),
                child: Text('Credited'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _filterTransactions(TransactionType.debit),
                child: Text('Debited'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = _filteredTransactions[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Card(
                    elevation: 4,
                    color: Colors
                        .grey[200], // Changed card color for better visibility
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        transaction.type == TransactionType.credit
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: transaction.type == TransactionType.credit
                            ? Colors.lightGreen
                            : Colors.red,
                      ),
                      title: Text(
                        '${transaction.type == TransactionType.credit ? 'Credited' : 'Debited'}: ₹${transaction.amount}',
                        style: TextStyle(
                          color: transaction.type == TransactionType.credit
                              ? Colors.lightGreen
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${transaction.date}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      trailing: Icon(
                        transaction.category.icon,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpenseManuallyDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

enum TransactionType { credit, debit }

class Transaction {
  final double amount;
  final TransactionType type;
  final DateTime date;
  final TransactionCategory category;

  Transaction({
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });

  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Transaction(
      amount: data['amount'],
      type: data['type'] == 'credit'
          ? TransactionType.credit
          : TransactionType.debit,
      date: (data['date'] as Timestamp).toDate(),
      category: TransactionCategory(
        icon: Icons.shopping_cart,
        name: "Firestore",
      ),
    );
  }
}

class TransactionCategory {
  final IconData icon;
  final String name;

  TransactionCategory({required this.icon, required this.name});
}

void main() {
  runApp(MaterialApp(
    home: SpendHistoryPage(),
  ));
}
