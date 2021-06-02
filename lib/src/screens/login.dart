import 'package:DemoMenu/src/screens/mainapp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(accentColor: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.supervised_user_circle,
                    color: Colors.blue,
                    size: 170,
                  )),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Entrez une adresse email';
                      } else if (!value.contains('@')) {
                        return 'Entrez une adresse email valide';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Mot de passe'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Entrez un mot de passe';
                        } else if (value.length < 6) {
                          return 'Le mot de passe doit faire au moins 6 caractères';
                        }
                        return null;
                      })),
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('Connexion'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      login();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  void login() {
    auth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainApp()),
      );
    }).catchError((err) {
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Erreur"),
              content: Text(err.message),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }
}
