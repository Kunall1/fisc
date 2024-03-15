import 'dashboard_split.dart';
import 'manage_expense.dart';
import 'spend_history.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  final List<double> incomeData = [2000, 2500, 1500, 3000, 2000, 3500];
  final List<double> expenseData = [1500, 2000, 1800, 2500, 2200, 2800];

  final List<BudgetItem> budgetItems = [
    BudgetItem(category: 'Food', amount: 500),
    BudgetItem(category: 'Transportation', amount: 300),
    BudgetItem(category: 'Entertainment', amount: 200),
    BudgetItem(category: 'Shopping', amount: 400),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FISC',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 255, 255, 255), Colors.white],
          ),
        ),
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardButton(
                  label: 'This Month Spends',
                  value: '',
                  icon: Icons.attach_money,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpendHistoryPage(),
                      ),
                    );
                  },
                ),
                DashboardButton(
                  label: 'Manage Expenses',
                  value: 'Limit',
                  icon: Icons.score,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageExpensesPage(),
                      ),
                    );
                  },
                ),
                DashboardButton(
                  label: 'Split Bill',
                  value: '',
                  icon: Icons.money,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SplitDashboardScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Income',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 111, 172, 85),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                      flex: 2,
                      child: BarChart(
                        _generateBarChartData(
                            context, Colors.green, incomeData),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    const Text(
                      'Expenses',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                      flex: 2,
                      child: BarChart(
                        _generateBarChartData(
                            context, Colors.orange, expenseData),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartData _generateBarChartData(
      BuildContext context, Color barColor, List<double> data) {
    return BarChartData(
      barGroups: List.generate(data.length, (index) {
        return BarChartGroupData(
          x: index.toInt(),
          barRods: [
            BarChartRodData(
              fromY: data[index],
              color: barColor,
              width: 16,
              toY: 50,
            ),
          ],
        );
      }),
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(enabled: false),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Function()? onPressed;

  const DashboardButton({
    required this.label,
    required this.value,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: 120.0,
          width: 120.0,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 187, 189, 184),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              SizedBox(height: 10.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Changed to white
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Changed to white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BudgetItem {
  final String category;
  final double amount;

  BudgetItem({required this.category, required this.amount});
}

void main() {
  runApp(MaterialApp(
    home: DashboardScreen(),
    theme: ThemeData(
      fontFamily: 'Raleway',
    ),
  ));
}
