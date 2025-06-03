import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class orderhistorypage extends StatefulWidget {
  const orderhistorypage({super.key});

  @override
  State<orderhistorypage> createState() => _orderhistorypageState();
}

class _orderhistorypageState extends State<orderhistorypage> {
  CollectionReference ordersRef =
      FirebaseFirestore.instance.collection("History");
  User? user = FirebaseAuth.instance.currentUser;
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
              stream: ordersRef.where("Uid", isEqualTo: user!.uid).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data!.docs.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/nodata.json"),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "No orders yet !",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    var ID = snapshot.data!.docs[index].id;
                    return InkWell(
                      onTap: () {
                        //Navigate to order history details
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 300,
                          width: 300,
                          padding: EdgeInsets.all(3),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      width: 90,
                                      child: documentSnapshot["ordered"] ==
                                              false
                                          ? Icon(
                                              CupertinoIcons.alarm_fill,
                                              size: 45,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )
                                          : Icon(
                                              CupertinoIcons.hand_thumbsup_fill,
                                              size: 45,
                                              color: Color.fromARGB(
                                                  255, 21, 250, 29),
                                            )),
                                  Container(
                                      width: 90,
                                      child:
                                          documentSnapshot["orderAccepted"] ==
                                                  false
                                              ? Icon(
                                                  CupertinoIcons.percent,
                                                  size: 45,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )
                                              : Icon(
                                                  CupertinoIcons
                                                      .hand_thumbsup_fill,
                                                  size: 45,
                                                  color: Color.fromARGB(
                                                      255, 21, 250, 29),
                                                )),
                                  Container(
                                      width: 90,
                                      child: documentSnapshot["orderRaedy"] ==
                                              false
                                          ? Icon(
                                              CupertinoIcons.hammer,
                                              size: 45,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )
                                          : Icon(
                                              CupertinoIcons.hand_thumbsup_fill,
                                              size: 45,
                                              color: Color.fromARGB(
                                                  255, 21, 250, 29),
                                            )),
                                  Container(
                                      width: 90,
                                      child: documentSnapshot["orderPicked"] ==
                                              false
                                          ? Icon(
                                              CupertinoIcons.wand_stars_inverse,
                                              size: 45,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )
                                          : Icon(
                                              CupertinoIcons.hand_thumbsup_fill,
                                              size: 45,
                                              color: Color.fromARGB(
                                                  255, 21, 250, 29),
                                            )),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                    color: documentSnapshot["orderAccepted"] ==
                                            false
                                        ? Colors.grey.shade300
                                        : Color.fromARGB(255, 21, 250, 29),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 90,
                                    color:
                                        documentSnapshot["orderRaedy"] == false
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      height: 150,
                                      width: 90,
                                      child:
                                          documentSnapshot["ordered"] == false
                                              ? Text(
                                                  "Order on wait",
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
                                      height: 150,
                                      width: 90,
                                      child:
                                          documentSnapshot["orderAccepted"] ==
                                                  false
                                              ? Text(
                                                  "Order in process",
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
                                      height: 150,
                                      width: 90,
                                      child: documentSnapshot["orderRaedy"] ==
                                              false
                                          ? Text(
                                              "Order in prepair",
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            )
                                          : Text("Order ready to pick up",
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  color: Theme.of(context)
                                                      .primaryColor))),
                                  Container(
                                      height: 150,
                                      width: 90,
                                      child: documentSnapshot["orderPicked"] ==
                                              false
                                          ? Text(
                                              "Order waiting for you",
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
