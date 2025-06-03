// ignore_for_file: unused_import, prefer_const_constructors, non_constant_identifier_names, deprecated_member_use, unused_local_variable

import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/Log%20&%20Regster/AdminRegister.dart';
import 'package:graduationpro/Log%20&%20Regster/LogIn.dart';
import 'package:graduationpro/Log%20&%20Regster/Registercust.dart';
import 'package:graduationpro/adminPages/addappointmentspage.dart';
import 'package:graduationpro/adminPages/addcar.dart';
import 'package:graduationpro/adminPages/addpartspage.dart';
import 'package:graduationpro/adminPages/edit.dart';
import 'package:graduationpro/adminPages/editcustomers.dart';
import 'package:graduationpro/adminPages/editndltappage.dart';
import 'package:graduationpro/adminPages/editndltpage.dart';
import 'package:graduationpro/customerPages/carspage.dart';
import 'package:graduationpro/customerPages/cartpage.dart';
import 'package:graduationpro/customerPages/homepage.dart';
import 'package:graduationpro/customerPages/reservationpage.dart';
import 'package:graduationpro/designs/adminbottombar.dart';
import 'package:graduationpro/designs/bottombar.dart';
import 'package:graduationpro/designs/pushnot.dart';
import 'package:graduationpro/designs/splash.dart';
import 'package:hexcolor/hexcolor.dart';

var isLogin = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color BlueColor = HexColor("#04207d");
  Color WhiteColor = HexColor("#f0f2f5");
  User? user;
  @override
  void initState() {
// AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//       if (!isAllowed) {
//         AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
// TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: BlueColor,
        accentColor: WhiteColor,
      ),
      home: splash(),
    );
  }
}
