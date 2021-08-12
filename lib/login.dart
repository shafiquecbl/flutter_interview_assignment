import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview_assignment/Home_Page.dart';
import 'package:flutter_interview_assignment/Widgets/loading.dart';
import 'package:flutter_interview_assignment/Widgets/navigator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Column(
                  children: [
                    TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter username",
                          labelText: "Username",
                        ),
                        validator: (value) {}),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter password",
                        labelText: "Password",
                      ),
                      validator: (value) {},
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                          primary: Colors.deepPurpleAccent),
                      onPressed: () {
                        signin();
                      },
                      icon: Icon(Icons.login),
                      label: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  signin() {
    showLoading(context);
    FirebaseAuth.instance
        .signInAnonymously()
        .then((value) => navigatorRemove(context, HomePage()));
  }
}
