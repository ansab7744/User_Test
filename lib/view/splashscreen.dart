import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // void initState() {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("User",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w800),))
        ],
      )
    ); 
  }
}