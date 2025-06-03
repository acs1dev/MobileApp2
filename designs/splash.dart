// ignore_for_file: prefer_final_fields, unnecessary_new, deprecated_member_use, prefer_const_constructors, sort_child_properties_last, camel_case_types

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/Log%20&%20Regster/LogIn.dart';
import 'package:graduationpro/customerPages/homepage.dart';
import 'package:graduationpro/designs/adminbottombar.dart';
import 'package:graduationpro/designs/bottombar.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  bool _isVisible = false;
  User? user = FirebaseAuth.instance.currentUser;

  _splashState() {
    new Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        FirebaseFirestore.instance
            .collection("User")
            .doc(user!.uid)
            .get()
            .then((DocumentSnapshot snapshot) {
          if (snapshot.get("RoleID") == 1) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => user != null ? bottombar() : LogIn()),
                (route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        user != null ? adminbottombar() : LogIn()),
                (route) => false);
          }
        });
      });
    });
    new Timer(Duration(milliseconds: 10), (() {
      setState(() {
        _isVisible = true;
      });
    }));
  }

  // triggernot() {
  //   AwesomeNotifications().createNotification(

  //       content: NotificationContent(
  //         id: 10,
  //         channelKey: 'basic_channel',
  //         title: 'We are sorry to inform you',
  //         body: 'That your appointment has been deleted you can reserve a new one any time. Thank you',
  //         )
  //         );
  // }

  CollectionReference appRef =
      FirebaseFirestore.instance.collection("Appointments");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appRef
        .where("Date", isLessThan: DateTime.now())
        .get()
        .then((value) => value.docs.forEach((element) {
              appRef.doc(element.id).update({"Ex": true});
            }));
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor
              ],
              begin: const FractionalOffset(0, 0),
              end: const FractionalOffset(5.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: Duration(milliseconds: 1200),
        child: Center(
          child: ClipOval(child: Lottie.asset("assets/bluecar.json")),
        ),
      ),
    );
  }
}
