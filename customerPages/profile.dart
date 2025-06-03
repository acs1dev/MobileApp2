// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/customerPages/viewpage.dart';
import 'package:graduationpro/customerPages/homepage.dart';
import 'package:graduationpro/customerPages/editpro.dart';
import 'package:graduationpro/customerPages/editpro.dart';
import 'package:graduationpro/customerPages/viewpage.dart';
import 'package:graduationpro/designs/bottombar.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  CollectionReference useRef = FirebaseFirestore.instance.collection("User");
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  Icon(
                    Icons.edit,
                    size: 45,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "My Profile",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: useRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 220,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (snapshot.data!.docs[index]["email"] ==
                            user!.email) {
                          return Container(
                            height: 200,
                            child: ListView(
                              children: [
                                Container(
                                  height: 150,
                                  child: Card(
                                    borderOnForeground: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: ListView(
                                        children: [
                                          Text(
                                            "Name  : " +
                                                snapshot.data!.docs[index]
                                                    ["Name"],
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              "Phone : " +
                                                  snapshot.data!
                                                      .docs[index]["Phone"]
                                                      .toString(),
                                              style: TextStyle(fontSize: 20)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              "Email  : " +
                                                  snapshot.data!.docs[index]
                                                      ["email"],
                                              style: TextStyle(fontSize: 20))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return Text("");
                        }
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 50,
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Home",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return bottombar();
                  },
                ));
              },
            ),
            // InkWell(
            //     child: Padding(
            //       padding: const EdgeInsets.all(5.0),
            //       child: Container(
            //         height: 50,
            //         child: Card(
            //           color: Theme.of(context).primaryColor,
            //           borderOnForeground: true,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //           child: Padding(
            //             padding: const EdgeInsets.all(10.0),
            //             child: Row(
            //               children: [
            //                 Icon(CupertinoIcons.cart_fill, color: Colors.white),
            //                 SizedBox(
            //                   width: 5,
            //                 ),
            //                 Text(
            //                   "Cart",
            //                   style: TextStyle(
            //                       fontSize: 18,
            //                       fontWeight: FontWeight.bold,
            //                       color: Colors.white),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     onTap: () {
            //       Navigator.push(context, MaterialPageRoute(
            //         builder: (context) {
            //           return bottombar();
            //         },
            //       ));
            //     }),
            InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 50,
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      borderOnForeground: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.time, color: Colors.white),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Appointments",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return viewpage();
                    },
                  ));
                }),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return editpro();
                          },
                        ));
                      },
                      child: Text("Edit Your Information"))),
            ),
          ],
        ),
      ),
    );
  }
}
