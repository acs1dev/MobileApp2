// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/designs/themes.dart';
import 'package:graduationpro/customerPages/profile.dart';
import 'package:lottie/lottie.dart';

class editpro extends StatefulWidget {
  const editpro({super.key});

  @override
  State<editpro> createState() => _editproState();
}

class _editproState extends State<editpro> {
  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();

  CollectionReference useRef = FirebaseFirestore.instance.collection("User");
  User? user = FirebaseAuth.instance.currentUser;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  update() {
    var formData = formstate.currentState;
    formData!.save();
    final int? numbers = int.tryParse(phone.text);
    FirebaseFirestore.instance
        .collection("User")
        .doc(user!.uid)
        .update({"Name": name.text, "Phone": numbers}).then(
            (value) => Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return profile();
                  },
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formstate,
        child: ListView(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 45,
                          color: Theme.of(context).accentColor,
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.edit,
                    size: 45,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Edit Profile",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Icon(
              CupertinoIcons.profile_circled,
              size: 170,
            ),
            SizedBox(
              height: 30,
            ),
            StreamBuilder(
              stream: useRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 300,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (snapshot.data!.docs[index]["email"] ==
                            user!.email) {
                          return Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 15),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !RegExp(r'^[a-z A-Z]+$')
                                              .hasMatch(value)) {
                                        return "Enter correct Name";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: name,
                                    decoration: TextBoxDesign().TextInputo(
                                        snapshot.data!.docs[index]["Name"],
                                        "Enter Full Name",
                                        Icons.person),
                                    keyboardType: TextInputType.name,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 15),
                                  child: TextFormField(
                                    controller: phone,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !RegExp(r'^[0-9]+$')
                                              .hasMatch(value)) {
                                        return "Enter correct Phone number";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: TextBoxDesign().TextInputo(
                                        snapshot.data!.docs[index]["Phone"]
                                            .toString(),
                                        "Enter Phone Number",
                                        Icons.phone),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                    height: 50,
                                    width: 200,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0)),
                                        ),
                                        onPressed: () async {
                                          if (formstate.currentState!
                                              .validate()) {
                                            update();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Enter currect Information")));
                                          }
                                        },
                                        child: Text("Update"))),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: 0,
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: ClipOval(
                        child: Lottie.network(
                      "https://assets1.lottiefiles.com/packages/lf20_znxtcbvh33.json",
                    )),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
