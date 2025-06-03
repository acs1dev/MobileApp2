import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/Log%20&%20Regster/LogIn.dart';

class verifiy extends StatefulWidget {
  const verifiy({super.key});

  @override
  State<verifiy> createState() => _verifiyState();
}

class _verifiyState extends State<verifiy> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;
  @override
  void initState() {
    user = auth.currentUser;
    user!.sendEmailVerification();
    super.initState();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("an email sent to${{user!.email}} please verify"),
          )
        ],
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user!.reload();
    if (user!.emailVerified) {
      timer!.cancel();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return LogIn();
        },
      ));
    }
  }
}
