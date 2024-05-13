import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  int duration;
  Widget goToPage;

  SplashPage({required this.duration, required this.goToPage});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => goToPage),
      );
    });
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/Marvel_Logo.png'),
          )),
    );
  }
}
