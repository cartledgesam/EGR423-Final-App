import 'package:flutter/material.dart';

import './screens/profile_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: SplashScreen(),
      routes: {
        ProfileScreen.routeName: (context) => ProfileScreen(),
      },
    );
  }
}
