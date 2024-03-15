import 'spend_history.dart';

import 'humans_provider.dart';
import 'register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'group_provider.dart';
import 'friends_provider.dart';
import 'payment_provider.dart';
import 'user_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'humans_provider.dart';
import 'signup_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GroupProvider()),
        ChangeNotifierProvider(
          create: (_) =>
              FriendsProvider(FirebaseAuth.instance.currentUser?.uid ?? ''),
        ),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
            create: (_) =>
                HumansProvider(FirebaseAuth.instance.currentUser?.uid ?? ''))
      ],
      child: MaterialApp(
        title: 'Your App Title',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
        routes: {
          '/signup': (context) => SignupScreen(),
          '/main': (context) => MainPage(),
        },
      ),
    ),
  );
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DashboardButton(
              label: 'This Month Spends',
              value: '\$500', // Replace with actual value
              onPressed: () {
                // Navigate to SpendHistoryPage when button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpendHistoryPage()),
                );
              },
            ),
            SizedBox(height: 20.0),
            DashboardButton(
              label: 'Credit Score',
              value: '750', // Replace with actual value
              onPressed: () {
                // Implement action for Credit Score button
              },
            ),
            SizedBox(height: 20.0),
            DashboardButton(
              label: 'Offers',
              value: '3', // Replace with actual number of offers
              onPressed: () {
                // Implement action for Offers button
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String label;
  final String value;
  final Function()? onPressed;

  const DashboardButton({
    required this.label,
    required this.value,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          padding: EdgeInsets.all(20.0),
          backgroundColor: Colors.black.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}