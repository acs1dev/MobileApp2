// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/designs/themes.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  var Email, password;
  GlobalKey<FormState> formstate = new GlobalKey();
  CollectionReference useref = FirebaseFirestore.instance.collection("User");
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController forgetpass = TextEditingController();

  updateData() async {
    var formData = formstate.currentState;
    formData!.save();
    if (Email == user!.email) {
      FirebaseFirestore.instance
          .collection("User")
          .doc(user!.uid)
          .set({'password': password}, SetOptions(merge: true));
    } else {
      print("object");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Form(
              key: formstate,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 250,
                    ),
                    TextFormField(
                      controller: forgetpass,
                      decoration: TextBoxDesign()
                          .TextInputo("Email", "Enter your Email", Icons.email),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            //borderRadius: BorderRadius.circular(100)

                            ),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                            ),
                            onPressed: () async {
                              var forgotEmail = forgetpass.text.trim();
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: forgotEmail)
                                    .then((value) => {
                                          print("Email sent"),
                                        });
                              } on FirebaseAuthException catch (e) {
                                print("Error $e");
                              }
                            },
                            child: Text("Send"))),
                  ],
                ),
              ))
        ],
      )),
    );
  }
}
