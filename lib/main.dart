import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'view/HomePage/homepage.dart';
import 'view/loginPage/loginpage.dart';
import 'view/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 3)),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: SplashScreen(),
              );
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return HomePage();
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SplashScreen();
                      } else {
                        return LoginPage();
                      }
                    }),
              );
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}
