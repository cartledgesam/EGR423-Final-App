import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/profile_screen.dart';
import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        future: _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: Colors.black,
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.blueGrey,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            home: appSnapshot.connectionState != ConnectionState.done
                ? SplashScreen()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, userSnapshot) {
                      // checks if we are logged in, then show the Chat Screen
                      if (userSnapshot.hasData) {
                        return HomeScreen();
                      }
                      return const AuthScreen();
                    },
                  ),
            routes: {
              ProfileScreen.routeName: (context) => ProfileScreen(),
            },
          );
        });
  }
}
