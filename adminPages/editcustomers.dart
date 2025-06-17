import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/designs/pushnot.dart';
import 'package:graduationpro/designs/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class editcustomers extends StatefulWidget {
  const editcustomers({super.key});

  @override
  State<editcustomers> createState() => _editcustomersState();
}

class _editcustomersState extends State<editcustomers> {
  List custList = [];
  CollectionReference custRef = FirebaseFirestore.instance.collection("User");
  Showcust() async {
    var response = await custRef.get();
    response.docs.forEach((element) {
      setState(() {
        custList.add(element.data());
      });
    });
    print("-------------------------");
    print(custList);
  }

  TextEditingController _name = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _email = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  delete() {
    FirebaseFirestore.instance.collection("Parts").doc(user!.uid).delete();
  }

  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _name.text = documentSnapshot["Name"];
      _number.text = documentSnapshot["Phone"];
      _email.text = documentSnapshot["email"];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: TextFormField(
                      controller: _name,
                      decoration: TextBoxDesign().TextInputo("", "", Icons.abc),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: _number,
                      decoration: TextBoxDesign().TextInputo("", "", Icons.abc),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text(
                              "Cancel".toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text(
                              "Update".toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_name.text != null && _number.text != null) {
                              await custRef.doc(documentSnapshot!.id).update({
                                "Name": _name.text,
                                "Phone": _number.text,
                              });

                              _name.text = '';
                              _number.text = '';
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 40,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    Text(
                                      "updated successfuly",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 23),
                                    ),
                                  ],
                                ),
                                duration: Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                padding: EdgeInsets.all(20),
                                backgroundColor: Theme.of(context).primaryColor,
                              ));
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  SendNotification(String title, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };
    try {
      http.Response response =
          await http.post(Uri.parse('-_-'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    '*-*',
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body':
                      'Sorry but your appointment has been canceled, you can reschedule anytime thank you'
                },
                'priority': 'high',
                'data': data,
                'to': '$token'
              }));
      if (response.statusCode == 200) {
        print("Notification sent successfuly");
      } else {
        print("Error");
      }
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Showcust();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
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
                  width: 25,
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
                  "Edit & Delete users",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor),
                ),
              ],
            ),
          ),
          Container(
            height: 630,
            child: StreamBuilder(
              stream: custRef.where("RoleID", isEqualTo: 1).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Center();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    var ID = snapshot.data!.docs[index].id;
                    String mail = documentSnapshot["email"]
                        .substring(0, documentSnapshot["email"].indexOf('@'));
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 300,
                        width: 100,
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Name: ",
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${documentSnapshot["Name"]}",
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "E-mail: ",
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${mail}",
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Phone#: ",
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${documentSnapshot["Phone"]}",
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                            documentSnapshot["RoleID"] == 1
                                ? Row(
                                    children: [
                                      Text(
                                        "Role: ",
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "User",
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        "Role: ",
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Admin",
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ],
                                  ),
                            documentSnapshot["RoleID"] == 1
                                ? Column(
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50))),
                                          onPressed: () {
                                            SendNotification(
                                                "Reservation Cancel",
                                                documentSnapshot["token"]);
                                          },
                                          child: Text(
                                              "Notify reservation cancel")),
                                      // ElevatedButton(
                                      //     style: ElevatedButton.styleFrom(
                                      //         backgroundColor: Theme.of(context)
                                      //             .primaryColor,
                                      //         shape: RoundedRectangleBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(
                                      //                     50))),
                                      //     onPressed: () {
                                      //       update(documentSnapshot);
                                      //     },
                                      //     child: Text("Edit user")),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 252, 17, 0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50))),
                                          onPressed: () {
                                            QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.warning,
                                                animType:
                                                    QuickAlertAnimType.rotate,
                                                cancelBtnText: "No",
                                                onCancelBtnTap: () {
                                                  Navigator.pop(context);
                                                },
                                                confirmBtnText: "Yes",
                                                onConfirmBtnTap: () {
                                                  custRef.doc(ID).delete();
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(
                                                          Icons.check_circle,
                                                          size: 40,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                        ),
                                                        Text(
                                                          "User deleted successfuly",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor,
                                                              fontSize: 23),
                                                        ),
                                                      ],
                                                    ),
                                                    duration:
                                                        Duration(seconds: 3),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    padding: EdgeInsets.all(20),
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                  ));
                                                },
                                                showCancelBtn: true,
                                                title: "USER DELETE",
                                                text:
                                                    "Are you sure you want to delete this user: ${documentSnapshot["Name"]} ?");
                                          },
                                          child: Text("Delete user"))
                                    ],
                                  )
                                : Center()
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 3),
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).accentColor),
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
