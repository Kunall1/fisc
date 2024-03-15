import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import your dashboard page file
import 'dart:math';

class ManageExpensesPage extends StatefulWidget {
  @override
  _ManageExpensesPageState createState() => _ManageExpensesPageState();
}

class _ManageExpensesPageState extends State<ManageExpensesPage> {
  double monthlyIncome = 0.0;
  double expenseLimit = 0.0;
  String frequency = 'Monthly';
  double fdInvestment1Year = 0.0;
  double fdInvestment5Year = 0.0;
  double fdInvestment10Year = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Expenses'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.0),
              Text(
                'Monthly Income',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter your monthly income',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    monthlyIncome = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Expense Limit',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter your expense limit',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    expenseLimit = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Frequency',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              DropdownButton<String>(
                value: frequency,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  setState(() {
                    frequency = newValue!;
                  });
                },
                items: <String>['Daily', 'Weekly', 'Monthly']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Calculate savings based on income, limit, and frequency
                  double savings = _calculateSavings();
                  // Calculate the FD investments
                  _calculateFDInvestments(savings);
                  // Show dialog with calculated savings
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Estimated Savings'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'You could save approximately \Rs${savings.toStringAsFixed(2)} in a month.',
                            ),
                            SizedBox(height: 10),
                            Text(
                              'FD Investment after 1 year: \Rs${fdInvestment1Year.toStringAsFixed(2)}',
                            ),
                            Text(
                              'FD Investment after 5 years: \Rs${fdInvestment5Year.toStringAsFixed(2)}',
                            ),
                            Text(
                              'FD Investment after 10 years: \Rs${fdInvestment10Year.toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Calculate Savings'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the dashboard page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
                child: Text('Go Back to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateSavings() {
    double savings = 0.0;
    switch (frequency) {
      case 'Daily':
        savings = (monthlyIncome - expenseLimit) * 365 / 12;
        break;
      case 'Weekly':
        savings = (monthlyIncome - expenseLimit) * 52 / 12;
        break;
      case 'Monthly':
        savings = monthlyIncome - expenseLimit;
        break;
    }
    return savings;
  }

  void _calculateFDInvestments(double savings) {
    // Interest rate for FD (7% per annum)
    double interestRate = 0.07;
    // Number of years for investments
    int years1 = 1;
    int years5 = 5;
    int years10 = 10;
    // Calculate FD investments
    fdInvestment1Year = fdInvestment1Year =
        savings * (pow(1 + interestRate, years1) - 1) / interestRate;
    fdInvestment5Year = fdInvestment5Year =
        savings * (pow(1 + interestRate, years5) - 1) / interestRate;
    fdInvestment10Year =
        savings * (pow(1 + interestRate, years10) - 1) / interestRate;
  }
}

void main() {
  runApp(MaterialApp(
    home: ManageExpensesPage(),
  ));
}
