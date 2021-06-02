import 'package:DemoMenu/src/screens/login.dart';
import 'package:DemoMenu/src/screens/mainapp.dart';
//import 'package:DemoMenu/src/screens/mainapp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'AppFlutter',
        theme: ThemeData(accentColor: Colors.blue),
        home: FirebaseAuth.instance.currentUser != null
            ? MainApp()
            : LoginScreen());
  }
}
