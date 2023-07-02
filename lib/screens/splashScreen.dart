import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellbuyrentcar/screens/HomeScreen.dart';
import 'package:sellbuyrentcar/screens/authenticationScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(Duration(seconds: 3), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      } else {
        Route newRoute = MaterialPageRoute(builder: (context) => AuthenticationScreen());
        Navigator.pushReplacement(context, newRoute);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Colors.blueGrey,
                Colors.deepPurple,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/logo.png'),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Rent Buy Sell Cars Online",
                style: TextStyle(fontSize: 60.0, color: Colors.white, fontFamily: "Lobster"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
