// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/designs/bottombar.dart';
// import 'package:gradpro/appointment/reserv.dart';
// import 'package:gradpro/homepage.dart';
import 'package:intl/intl.dart';

class viewpage extends StatefulWidget {
  const viewpage({super.key});

  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {
  List aaList = [];
  CollectionReference appref =
      FirebaseFirestore.instance.collection("Appointments");
  User? user = FirebaseAuth.instance.currentUser;
  show() async {
    var response = await appref.where("for", isEqualTo: user!.email).get();
    response.docs.forEach((element) {
      setState(() {
        aaList.add(element.data());
      });
    });
  }

  bool _isVisible = false;

  _splashState() {
    new Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => viewpage()),
            (route) => false);
      });
    });
    new Timer(Duration(milliseconds: 10), (() {
      setState(() {
        _isVisible = true;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return bottombar();
                            },
                          ));
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
                    "View appointment",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: appref.where("For", isEqualTo: user!.email).snapshots(),
              builder: (context, snapshot) {
                return Container(
                  height: 600,
                  width: 400,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      DateTime date = documentSnapshot["Date"].toDate();
                      String time = DateFormat.Hms().format(date);
                      String da = DateFormat.yMMMd().format(date);

                      //return Text(snapshot.data!.docs[index]["For"].toString());
                      return Card(
                        borderOnForeground: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 10),
                            //   child: Text(
                            //     snapshot.data!.docs[index]["For"],
                            //     style: TextStyle(fontSize: 12),
                            //   ),
                            // ),
                            Text(
                              da,
                              style: TextStyle(
                                fontSize: 23,
                              ),
                            ),
                            Text(
                              time + " AM",
                              style: TextStyle(
                                fontSize: 23,
                              ),
                            ),
                            SizedBox(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                  ),
                                  onPressed: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    //   return reserv();
                                    // },));
                                    // appref.doc(ID)
                                  },
                                  child: Text("Edit")),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
