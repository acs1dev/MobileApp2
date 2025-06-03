import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class orderhisntrkpage extends StatefulWidget {
  const orderhisntrkpage({super.key});

  @override
  State<orderhisntrkpage> createState() => _orderhisntrkpageState();
}

class _orderhisntrkpageState extends State<orderhisntrkpage> {
  CollectionReference ordersRef =
      FirebaseFirestore.instance.collection("History");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 62),
            child: Container(
              height: 70,
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
                    width: 30,
                  ),
                  Icon(
                    Icons.history,
                    color: Theme.of(context).accentColor,
                    size: 45,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "My Orders history",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 630,
            child: StreamBuilder(
              stream: ordersRef.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
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
                        width: 300,
                        padding: EdgeInsets.all(3),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    width: 90,
                                    child: documentSnapshot["ordered"] == false
                                        ? IconButton(
                                            onPressed: () {
                                              ordersRef
                                                  .doc(ID)
                                                  .update({"ordered": true});
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
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    Text(
                                                      "Condition changed",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          fontSize: 23),
                                                    ),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 3),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                padding: EdgeInsets.all(20),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ));
                                            },
                                            icon: Icon(
                                              CupertinoIcons
                                                  .check_mark_circled_solid,
                                              size: 45,
                                              color: Color.fromARGB(
                                                  255, 21, 250, 29),
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              ordersRef
                                                  .doc(ID)
                                                  .update({"ordered": false});
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
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    Text(
                                                      "Condition changed",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          fontSize: 23),
                                                    ),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 3),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                padding: EdgeInsets.all(20),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ));
                                            },
                                            icon: Icon(
                                              CupertinoIcons.delete_left_fill,
                                              size: 45,
                                              color: Color.fromARGB(
                                                  255, 247, 16, 0),
                                            ))),
                                Container(
                                    width: 90,
                                    child: documentSnapshot["orderAccepted"] ==
                                            false
                                        ? IconButton(
                                            onPressed: () {
                                              ordersRef.doc(ID).update(
                                                  {"orderAccepted": true});
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
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    Text(
                                                      "Condition changed",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          fontSize: 23),
                                                    ),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 3),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                padding: EdgeInsets.all(20),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ));
                                            },
                                            icon: Icon(
                                              CupertinoIcons
                                                  .check_mark_circled_solid,
                                              size: 45,
                                              color: Color.fromARGB(
                                                  255, 21, 250, 29),
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              ordersRef.doc(ID).update(
                                                  {"orderAccepted": false});
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
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    Text(
                                                      "Condition changed",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          fontSize: 23),
                                                    ),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 3),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                padding: EdgeInsets.all(20),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ));
                                            },
                                            icon: Icon(
                                              CupertinoIcons.delete_left_fill,
                                              size: 45,
                                              color: Color.fromARGB(
                                                  255, 247, 16, 0),
                                            ))),
                                Container(
                                    width: 90,
                                    child: documentSnapshot["orderRaedy"] ==
                                            false
                                        ? IconButton(
                                            onPressed: () {
                                              ordersRef
                                                  .doc(ID)
                                                  .update({"orderRaedy": true});
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
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    Text(
                                                      "Condition changed",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          fontSize: 23),
                                                    ),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 3),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                padding: EdgeInsets.all(20),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ));
                                            },
                                            icon: Icon(
                                              CupertinoIcons
                                                  .check_mark_circled_solid,
                                              size: 45,
                                              color: Color.fromARGB(
                                                  255, 21, 250, 29),
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              ordersRef.doc(ID).update(
                                                  {"orderRaedy": false});
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
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    Text(
                                                      "Condition changed",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          fontSize: 23),
                                                    ),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 3),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                padding: EdgeInsets.all(20),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ));
                                            },
                                            icon: Icon(
                                              CupertinoIcons.delete_left_fill,
                                              size: 45,
                                              color: Color.fromARGB(
                                                  255, 247, 16, 0),
                                            ))),
                                Container(
                                    width: 90,
                                    child: documentSnapshot["orderPicked"] ==
                                            false
                                        ? IconButton(
                                            onPressed: () {
                                              ordersRef.doc(ID).update(
                                                  {"orderPicked": true});
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
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    Text(
                                                      "Condition changed",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          fontSize: 23),
                                                    ),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 3),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                padding: EdgeInsets.all(20),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ));
                                            },
                                            icon: Icon(
                                              CupertinoIcons
                                                  .check_mark_circled_solid,
                                              size: 45,
                                              color: Color.fromARGB(
                                                  255, 21, 250, 29),
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              ordersRef.doc(ID).update(
                                                  {"orderPicked": false});
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
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    Text(
                                                      "Condition changed",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          fontSize: 23),
                                                    ),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 3),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                padding: EdgeInsets.all(20),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ));
                                            },
                                            icon: Icon(
                                              CupertinoIcons.delete_left_fill,
                                              size: 45,
                                              color: Color.fromARGB(
                                                  255, 247, 16, 0),
                                            ))),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 10,
                                  width: 90,
                                  color: documentSnapshot["ordered"] == false
                                      ? Colors.grey.shade300
                                      : Color.fromARGB(255, 21, 250, 29),
                                ),
                                Container(
                                  height: 10,
                                  width: 90,
                                  color:
                                      documentSnapshot["orderAccepted"] == false
                                          ? Colors.grey.shade300
                                          : Color.fromARGB(255, 21, 250, 29),
                                ),
                                Container(
                                  height: 10,
                                  width: 90,
                                  color: documentSnapshot["orderRaedy"] == false
                                      ? Colors.grey.shade300
                                      : Color.fromARGB(255, 21, 250, 29),
                                ),
                                Container(
                                  height: 10,
                                  width: 90,
                                  color:
                                      documentSnapshot["orderPicked"] == false
                                          ? Colors.grey.shade300
                                          : Color.fromARGB(255, 21, 250, 29),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    height: 100,
                                    width: 90,
                                    child: documentSnapshot["ordered"] == false
                                        ? Text(
                                            "Recieve",
                                            style: TextStyle(
                                                fontSize: 23,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )
                                        : Text("Order recieved",
                                            style: TextStyle(
                                                fontSize: 23,
                                                color: Theme.of(context)
                                                    .primaryColor))),
                                Container(
                                    height: 100,
                                    width: 90,
                                    child: documentSnapshot["orderAccepted"] ==
                                            false
                                        ? Text(
                                            "Accept",
                                            style: TextStyle(
                                                fontSize: 23,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )
                                        : Text("Order accepted",
                                            style: TextStyle(
                                                fontSize: 23,
                                                color: Theme.of(context)
                                                    .primaryColor))),
                                Container(
                                    height: 100,
                                    width: 90,
                                    child:
                                        documentSnapshot["orderRaedy"] == false
                                            ? Text(
                                                "Ready",
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              )
                                            : Text("Order ready",
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    color: Theme.of(context)
                                                        .primaryColor))),
                                Container(
                                    height: 100,
                                    width: 90,
                                    child:
                                        documentSnapshot["orderPicked"] == false
                                            ? Text(
                                                "Picked",
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              )
                                            : Text("Order Picked",
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    color: Theme.of(context)
                                                        .primaryColor))),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "E-mail: ",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                                Text(
                                  mail,
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Order number: ",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                                Text(
                                  "${documentSnapshot["OrderNO"]}",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Total price: ",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                                Text(
                                  "${documentSnapshot["Total"]} SR",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2.5),
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).accentColor),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
