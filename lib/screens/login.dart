import 'package:flutter/material.dart';
import 'package:sellbuyrentcar/DialogBox/errorDialog.dart';
import 'package:sellbuyrentcar/DialogBox/loadingDialog.dart';
import 'package:sellbuyrentcar/screens/HomeScreen.dart';
import 'package:sellbuyrentcar/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  'images/login.png',
                  height: 270.0,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    data: Icons.person,
                    controller: _emailController,
                    hintText: 'Email',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: _passwordController,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.08,
              child: ElevatedButton(
                onPressed: () {
                  _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
                      ? _login()
                      : showDialog(
                          context: context,
                          builder: (con) {
                            return ErrorAlertDialog(
                              message: 'Please write the required info for Login.',
                            );
                          });
                },
                child: Text(
                  'Log in',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    showDialog(
        context: context,
        builder: (con) {
          return LoadingAlertDialog(
            message: 'Please Wait',
          );
        });

    User? currentUser;

    await _auth
        .signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (con) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (currentUser != null) {
      Navigator.pop(context);
      Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, newRoute);
    } else {
      print("error");
    }
  }
}
