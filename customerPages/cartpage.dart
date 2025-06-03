import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graduationpro/customerPages/partspage.dart';
import 'package:graduationpro/customerPages/payment.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class cartpage extends StatefulWidget {
  cartpage({super.key});

  @override
  State<cartpage> createState() => _cartpageState();
}

class _cartpageState extends State<cartpage> {
  var date = DateTime.now();
  List cartList = [];
  CollectionReference cartRef = FirebaseFirestore.instance.collection("Cart");

  Showcart() async {
    var response = await cartRef.get();
    response.docs.forEach((element) {
      setState(() {
        cartList.add(element.data());
      });
    });
    print("-------------------------");
    print(cartList.length);
    print(cartList);
  }

  List partsList = [];
  CollectionReference partRef = FirebaseFirestore.instance.collection("Parts");
  Showparts() async {
    var response = await partRef.get();
    response.docs.forEach((element) {
      setState(() {
        partsList.add(element.data());
      });
    });
    print("------------H-------------");
    print(partsList);
  }

  // UpdateAll() async {
  //   partRef.get().then((value) => value.docs.forEach((element) {
  //         partRef.doc(element.id).update({"Partquant": 1});
  //       }));
  // }

  // var stk;
  // var id;
  // var qnt;
  // getpref()async{
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   stk = pref.getInt("Stock");
  //   id = pref.getString("id");
  //   qnt = pref.getInt("qnt");
  //   print(stk);
  //   print(id);
  //   print(qnt);
  // }
  User? user = FirebaseAuth.instance.currentUser;
  // Showcart() async {
  //   var response = await cartRef.where("Useruid", isEqualTo: user!.uid).get();
  //   response.docs.forEach((element) {
  //     setState(() {
  //       cartList.add(element.data());
  //     });
  //   });
  //   print("-------------------------");
  //   print(cartList);
  // }

  delete() {
    FirebaseFirestore.instance.collection("Parts").doc(user!.uid).delete();
  }

  // date() {
  //   var date = DateTime.now();
  // }

  double total2 = 0;
  gettotal() {
    double total = 0;

    FirebaseFirestore.instance
        .collection("Cart")
        .where("Useruid", isEqualTo: user!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          total = total + element["Price"];
          total2 = total;
        });
      });
    });
  }

  int _Counter = 86400;
  late Timer _timer;
  void StartTimer() {
    _Counter = 86400;
    _timer = Timer.periodic(Duration(seconds: 1), ((timer) {
      if (_Counter > 0 && cartList.length > 0) {
        setState(() {
          _Counter--;
        });
      } else {
        _timer.cancel();
      }
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Showcart();
    gettotal();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Container(
              height: 70,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    CupertinoIcons.cart,
                    size: 35,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "My Cart",
                    style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 80,
                  ),
                  // Text(
                  //   _Counter.toString(),
                  //   style: TextStyle(
                  //       fontSize: 25,
                  //       color: Theme.of(context).accentColor,
                  //       fontWeight: FontWeight.bold),
                  // ),
                ],
              ),
            ),
          ),
          Container(
            height: 480,
            child: StreamBuilder(
              stream:
                  cartRef.where("Useruid", isEqualTo: user!.uid).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data!.docs.isEmpty) {
                  return Column(
                    children: [
                      Lottie.asset("assets/emptycart.json"),
                      Text(
                        "Sorry your cart is empty... !",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
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

                    return Column(
                      children: [
                        Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image(
                                image: NetworkImage(
                                    documentSnapshot["Image".toString()]),
                                height: 100,
                              ),
                              Column(
                                children: [
                                  Text(
                                    documentSnapshot["PartName"],
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "total: ",
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.grey.shade400),
                                      ),
                                      Text(documentSnapshot["Price"].toString(),
                                          style: TextStyle(fontSize: 22))
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                  documentSnapshot["Quantity"].toString() + "x",
                                  style: TextStyle(fontSize: 20)),
                              IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Cart")
                                        .doc(ID)
                                        .delete();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            size: 40,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          Text(
                                            "Successfully removed",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontSize: 23),
                                          ),
                                        ],
                                      ),
                                      duration: Duration(seconds: 3),
                                      behavior: SnackBarBehavior.floating,
                                      padding: EdgeInsets.all(20),
                                      backgroundColor:
                                          Color.fromARGB(255, 252, 21, 4),
                                    ));
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 35,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            height: 95,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 4,
                    ),
                    Text("Total :" + "$total2",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return payment();
                      // },));
                      cartRef
                          .where("Useruid", isEqualTo: user!.uid)
                          .get()
                          .then((val) => val.docs.forEach((element) {
                                partRef
                                    .where("Partid",
                                        isEqualTo: element.get("partid"))
                                    .get()
                                    .then((value) => value.docs.forEach((elem) {
                                          elem.get("Partquant") <
                                                  element.get("Quantity")
                                              ? QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.error,
                                                  text:
                                                      "SORRY THE AMOUNT OF PIECES YOU WANT ARE NOT AVAILABLE")
                                              : partRef.doc(elem.id).update({
                                                  "Partquant": element
                                                          .get("Stock") -
                                                      element.get("Quantity")
                                                });
                                        }));
                              }));
                    },
                    child: Text(
                      "Check out",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 3)),
          )
        ],
      ),
    );
  }
}
