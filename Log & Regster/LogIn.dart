// ignore_for_file: prefer_const_constructors, unused_import, sized_box_for_whitespace
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduationpro/designs/splash.dart';
// import 'package:gradpro/Adminhome.dart';
import 'package:graduationpro/designs/themes.dart';
import 'package:graduationpro/Log%20&%20Regster/Forget.dart';
import 'package:graduationpro/Log%20&%20Regster/Registercust.dart';
import 'package:graduationpro/designs/adminbottombar.dart';
import 'package:graduationpro/designs/bottombar.dart';
// import 'package:gradpro/homepage.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  var pass, emailAddress;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;

  lo() async {
    var formData = formstate.currentState;
    formData!.save();
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: pass);
      User? user = FirebaseAuth.instance.currentUser;
      var kk = FirebaseFirestore.instance
          .collection("User")
          .doc(user!.uid)
          .get()
          .then(
        (DocumentSnapshot snapshot) {
          if (snapshot.get("RoleID") == 1) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return splash();
              },
            ));
          } else {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return splash();
              },
            ));
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.info,
                size: 40,
                color: Theme.of(context).accentColor,
              ),
              Text(
                "Wrong user or password",
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 23),
              ),
            ],
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(20),
          backgroundColor: Color.fromARGB(255, 252, 21, 4),
        ));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.info,
                size: 40,
                color: Theme.of(context).accentColor,
              ),
              Text(
                "Wrong user or password",
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 23),
              ),
            ],
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(20),
          backgroundColor: Color.fromARGB(255, 252, 21, 4),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Form(
                // autovalidateMode: AutovalidateMode.always,
                key: formstate,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Image(
                      image: AssetImage("images/Logo.png"),
                      height: 270,
                    ),
                    Center(
                      child: Container(
                        height: 100,
                        child: Center(
                            child: Text(
                          "Welcome Back",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 20, bottom: 10),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border(),
                          borderRadius: BorderRadius.circular(30),
                          // color: Color.fromRGBO(150, 150, 157, 0.1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: TextFormField(
                            onSaved: (newValue) {
                              emailAddress = newValue;
                            },
                            decoration: TextBoxDesign().TextInputo(
                                "Email", "Enter Your Email", Icons.mail),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[\w-\@\.]+$').hasMatch(value)) {
                                return "Enter email";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 20, bottom: 10),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border(),
                          borderRadius: BorderRadius.circular(30),
                          // color: Color.fromRGBO(150, 150, 157, 0.1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: TextFormField(
                            onSaved: (newValue) {
                              pass = newValue;
                            },
                            decoration: TextBoxDesign().TextInputo(
                                "Password", "Enter Password", Icons.key),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Password";
                              } else {
                                return null;
                              }
                            },
                            obscureText: true,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Row(
                          children: [
                            Text("Do not have an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return Registercust();
                                    },
                                  ));
                                },
                                child: Text(
                                  "Register Now!!",
                                  style: TextStyle(color: Colors.lightBlue),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                            ),
                            onPressed: () {
                              if (formstate.currentState!.validate()) {
                                lo();
                              }
                            },
                            child: Text("LogIn"))),
                    Container(
                      height: 50,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Forget();
                              },
                            ));
                          },
                          child: Text("Forget Password?",
                              style: TextStyle(color: Colors.lightBlue))),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
