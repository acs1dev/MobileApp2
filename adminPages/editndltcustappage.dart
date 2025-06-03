import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/designs/pushnot.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class editndltcustappage extends StatefulWidget {
  const editndltcustappage({super.key});

  @override
  State<editndltcustappage> createState() => _editndltcustappageState();
}

class _editndltcustappageState extends State<editndltcustappage> {
  CollectionReference appRef =
      FirebaseFirestore.instance.collection("Appointments");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Container(
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
                  Icon(
                    CupertinoIcons.info_circle_fill,
                    size: 45,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Customer Reservations",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 650,
            child: StreamBuilder(
              stream: appRef.where("Reserved", isEqualTo: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return CircularProgressIndicator();
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    var ID = snapshot.data!.docs[index].id;
                    DateTime date = documentSnapshot["Date"].toDate();
                    String time = DateFormat.Hms().format(date);
                    String da = DateFormat.yMMMd().format(date);
                    String mail = documentSnapshot["For"]
                        .substring(0, documentSnapshot["For"].indexOf('@'));
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "For: " + mail,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 20),
                              ),
                            ),
                            Text(
                              da,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).accentColor),
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).accentColor),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.warning,
                                      animType: QuickAlertAnimType.rotate,
                                      cancelBtnText: "No",
                                      onCancelBtnTap: () {
                                        Navigator.pop(context);
                                      },
                                      confirmBtnText: "Yes",
                                      onConfirmBtnTap: () {
                                        FirebaseFirestore.instance
                                            .collection("Appointments")
                                            .doc(ID)
                                            .delete();
                                        Navigator.pop(context);
                                      },
                                      showCancelBtn: true,
                                      title: "RESERVATION DELETE",
                                      text:
                                          "Are you sure you want to delete this user: ${documentSnapshot["For"]} reservation ?");
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).accentColor),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ))
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
