// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/designs/themes.dart';
import 'package:graduationpro/designs/themes.dart';

class payment extends StatefulWidget {
  const payment({super.key});

  @override
  State<payment> createState() => _paymentState();
}

class _paymentState extends State<payment> {
  CollectionReference payRef = FirebaseFirestore.instance.collection("Cart");
  User? user = FirebaseAuth.instance.currentUser;
  var rand = (Random().nextInt(1000) + 1);
  add(String image, String name, double price, int quantity) async {
    FirebaseFirestore.instance.collection("orderhistory").add({
      "image": image,
      "Name": name,
      "ID": user!.uid,
      "email": user!.email,
      "price": price,
      "quantity": quantity,
      "orderNumber": rand,
      "ordered": false,
      "orderAccepted": false,
      "orderRaedy": false,
      "orderPicked": false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          height: 70,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 50,
                      color: Theme.of(context).accentColor,
                    )),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.payment,
                size: 45,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                "Payment",
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: TextBoxDesign().TextInputo(
                      "Card Name", "Enter CardName", Icons.credit_card),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: TextBoxDesign().TextInputo(
                      "CardNumber", "Enter CardNumber", Icons.credit_card),
                ),
              ),
              Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 185,
                      child: TextFormField(
                        decoration: TextBoxDesign()
                            .TextInputo("CVV", "Enter CVV ", Icons.password),
                      ),
                    ),
                    SizedBox(
                      width: 185,
                      child: TextFormField(
                        decoration: TextBoxDesign().TextInputo(
                            "Date", "Enter Expiration Date", Icons.date_range),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 330,
                child: StreamBuilder(
                  stream: payRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (snapshot.data!.docs[index]["Useruid"] ==
                              user!.uid) {
                            return Container(
                              height: 350,
                              width: 250,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Card(
                                      borderOnForeground: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                height: 70,
                                                child: Image(
                                                    image: NetworkImage(snapshot
                                                            .data!.docs[index]
                                                        ["Image"]))),
                                          ),
                                          Container(
                                            height: 25,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text("Name:"),
                                                Text(snapshot.data!.docs[index]
                                                    ["PartName"]),
                                              ],
                                            ),
                                          ),

                                          // Padding(
                                          //   padding: const EdgeInsets.only(right: 10),
                                          //   child:
                                          // ),
                                          Container(
                                            height: 25,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text("Price:"),
                                                Text(""),
                                                Text(snapshot
                                                    .data!.docs[index]["Price"]
                                                    .toString()),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 25,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text("Quantity:"),
                                                Text(""),
                                                Text(snapshot.data!
                                                    .docs[index]["Quantity"]
                                                    .toString())
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Center();
                          }
                        },
                      );
                    } else {
                      return Text("You Have an error");
                    }
                  },
                ),
              ),
              Container(
                height: 100,
                child: StreamBuilder(
                  stream: payRef.snapshots(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs[index]["Useruid"] ==
                              user!.uid) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: SizedBox(
                                  height: 50,
                                  width: 100,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                      ),
                                      onPressed: () {
                                        add(
                                            snapshot.data!.docs[index]["Image"],
                                            snapshot.data!.docs[index]
                                                ["PartName"],
                                            snapshot.data!.docs[index]["Price"],
                                            snapshot.data!.docs[index]
                                                ["Quantity"]);
                                      },
                                      child: Text("Pay"))),
                            );
                          } else {
                            return Center();
                          }
                        } else {
                          return Center();
                        }
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    print(rand.toString());
                  },
                  child: Text("aa"))
            ],
          ),
        ),
      ],
    ));
  }
}
