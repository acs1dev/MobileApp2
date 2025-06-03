import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class partdetailspage extends StatefulWidget {
  var partname;
  var carname;
  partdetailspage({super.key, required this.partname, required this.carname});

  @override
  State<partdetailspage> createState() => _partdetailspageState();
}

class _partdetailspageState extends State<partdetailspage> {
  List partsList = [];
  CollectionReference partsRef = FirebaseFirestore.instance.collection("Parts");
  User? user = FirebaseAuth.instance.currentUser;
  Showparts() async {
    var response =
        await partsRef.where("Partname", isEqualTo: widget.partname).get();
    response.docs
      ..forEach((element) {
        setState(() {
          partsList.add(element.data());
        });
      });
    print("-------------------------");
    print(partsList);
  }

  int quant = 1;
  List cartList = [];
  CollectionReference cartRef = FirebaseFirestore.instance.collection("Cart");
  ShowCart() async {
    var response = await cartRef.get();
    response.docs.forEach((element) {
      setState(() {
        cartList.add(element.data());
      });
    });
    print(cartList);
  }

  addpart(String prtname, double price, String img, String carname, int qyt,
      String IId, int stk, String Car) async {
    FirebaseFirestore.instance.collection("Cart").add({
      "PartName": prtname,
      "Price": price,
      "Image": img,
      "Car": carname,
      "Quantity": qyt,
      "partid": IId,
      "Stock": stk,
      "Useruid": user!.uid,
      "Car": Car
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("NONONONONONONON");
    Showparts();
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
            alignment: Alignment.center,
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
                  width: 60,
                ),
                Text(
                  "${widget.carname} ${widget.partname}",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            height: 650,
            width: double.infinity,
            child: StreamBuilder(
              stream: partsRef
                  .where("Partname", isEqualTo: widget.partname)
                  .where("Carname", isEqualTo: widget.carname)
                  .snapshots(),
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
                    return Column(
                      children: [
                        Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    documentSnapshot["Partimg"],
                                  ),
                                  fit: BoxFit.fill)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              documentSnapshot["Partname"],
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              documentSnapshot["Partprice"].toString() + " SR",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 32),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Description",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          height: 90,
                          width: 370,
                          alignment: Alignment.topLeft,
                          child: Text(documentSnapshot["Partdesc"],
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18)),
                        ),
                        documentSnapshot["Partquant"] > 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  quant == 1
                                      ? IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            CupertinoIcons.minus,
                                            size: 35,
                                          ))
                                      : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              quant--;
                                            });
                                          },
                                          icon: Icon(
                                            CupertinoIcons.minus,
                                            size: 35,
                                          )),
                                  Text(
                                    "${quant}",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  quant == documentSnapshot["Partquant"]
                                      ? IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.add,
                                            size: 35,
                                          ))
                                      : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              quant++;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            size: 35,
                                          )),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        documentSnapshot["Partquant"] == 0
                            ? Container(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0))),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.info,
                                            size: 40,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          Text(
                                            "Sorry this is out of stock",
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
                                  child: Text("Unavailable"),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  height: 50,
                                  width: 300,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0))),
                                    onPressed: () {
                                      partsRef.doc(documentSnapshot.id).update(
                                          {"Partid": documentSnapshot.id});

                                      addpart(
                                          documentSnapshot["Partname"],
                                          documentSnapshot["Partprice"] * quant,
                                          documentSnapshot["Partimg"],
                                          documentSnapshot["Carname"],
                                          quant,
                                          documentSnapshot.id,
                                          documentSnapshot["Partquant"],
                                          documentSnapshot["Carname"]);
                                      //        cartRef
                                      //     .where("Useruid",
                                      //         isEqualTo: user!.uid)
                                      //     .get()
                                      //     .then(
                                      //   (value) {
                                      //     value.docs.forEach((element) {
                                      //       partsRef
                                      //           .where("Partid",
                                      //               isEqualTo:
                                      //                   element.get("Partid"))
                                      //           .get()
                                      //           .then((valu) {
                                      //         valu.docs.forEach((elemen) {
                                      //           elemen.get("Partid") ==
                                      //                   element.get("partid")
                                      //               ? QuickAlert.show(
                                      //                   context: context,
                                      //                   type: QuickAlertType
                                      //                       .error)
                                      //               : addpart(
                                      //                   documentSnapshot[
                                      //                       "Partname"],
                                      //                   documentSnapshot[
                                      //                           "Partprice"] *
                                      //                       quant,
                                      //                   documentSnapshot[
                                      //                       "Partimg"],
                                      //                   documentSnapshot[
                                      //                       "Carname"],
                                      //                   quant,
                                      //                   documentSnapshot.id,
                                      //                   documentSnapshot[
                                      //                       "Partquant"],
                                      //                   documentSnapshot[
                                      //                       "Carname"]);
                                      //         });
                                      //       });
                                      //     });
                                      //   },
                                      // );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              size: 40,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            Text(
                                              "Successfully added to cart",
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
                                            Theme.of(context).primaryColor,
                                      ));
                                    },
                                    child: Text("Add to cart"),
                                  ),
                                ),
                              )
                      ],
                    );
                  },
                );
              },
            ),
            // child: partsList.isEmpty || partsList == null
            //     ? Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     : ListView.builder(
            //         itemCount: partsList.length,
            //         itemBuilder: (context, index) {
            //           return Column(
            //             children: [
            //               Container(
            //                 height: 300,
            //                 width: 300,
            //                 decoration: BoxDecoration(
            //                     color: Colors.grey.shade300,
            //                     borderRadius: BorderRadius.circular(20),
            //                     image: DecorationImage(
            //                         image: NetworkImage(
            //                           partsList[index]["Partimg"],
            //                         ),
            //                         fit: BoxFit.fill)),
            //               ),
            //               SizedBox(
            //                 height: 10,
            //               ),
            //               Row(
            //                 children: [
            //                   SizedBox(
            //                     width: 10,
            //                   ),
            //                   Text(
            //                     partsList[index]["Partname"],
            //                     style: TextStyle(
            //                         color: Theme.of(context).primaryColor,
            //                         fontSize: 32,
            //                         fontWeight: FontWeight.bold),
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(
            //                 height: 10,
            //               ),
            //               Row(
            //                 children: [
            //                   SizedBox(
            //                     width: 10,
            //                   ),
            //                   Text(
            //                     partsList[index]["Partprice"].toString() +
            //                         " SR",
            //                     style: TextStyle(
            //                         color: Theme.of(context).primaryColor,
            //                         fontSize: 32),
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(
            //                 height: 10,
            //               ),
            //               Row(
            //                 children: [
            //                   SizedBox(
            //                     width: 10,
            //                   ),
            //                   Text(
            //                     "Description",
            //                     style: TextStyle(
            //                         color: Theme.of(context).primaryColor,
            //                         fontSize: 25),
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(
            //                 height: 3,
            //               ),
            //               Container(
            //                 height: 90,
            //                 width: 370,
            //                 alignment: Alignment.topLeft,
            //                 child: Text(partsList[index]["Partdesc"],
            //                     style: TextStyle(
            //                         color: Theme.of(context).primaryColor,
            //                         fontSize: 18)),
            //               ),
            //               partsList[index]["Partquant"] > 0
            //                   ? Row(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         quant == 1
            //                             ? IconButton(
            //                                 onPressed: () {},
            //                                 icon: Icon(
            //                                   CupertinoIcons.minus,
            //                                   size: 35,
            //                                 ))
            //                             : IconButton(
            //                                 onPressed: () {
            //                                   setState(() {
            //                                     quant--;
            //                                   });
            //                                 },
            //                                 icon: Icon(
            //                                   CupertinoIcons.minus,
            //                                   size: 35,
            //                                 )),
            //                         Text(
            //                           "${quant}",
            //                           style: TextStyle(fontSize: 25),
            //                         ),
            //                         quant == partsList[index]["Partquant"]
            //                             ? IconButton(
            //                                 onPressed: () {},
            //                                 icon: Icon(
            //                                   Icons.add,
            //                                   size: 35,
            //                                 ))
            //                             : IconButton(
            //                                 onPressed: () {
            //                                   setState(() {
            //                                     quant++;
            //                                   });
            //                                 },
            //                                 icon: Icon(
            //                                   Icons.add,
            //                                   size: 35,
            //                                 )),
            //                       ],
            //                     )
            //                   : Container(),
            //               SizedBox(
            //                 height: 10,
            //               ),
            //               partsList[index]["Partquant"] == 0
            //                   ? Container(
            //                       height: 50,
            //                       width: 200,
            //                       child: ElevatedButton(
            //                         style: ElevatedButton.styleFrom(
            //                             backgroundColor: Colors.red,
            //                             shape: RoundedRectangleBorder(
            //                                 borderRadius:
            //                                     BorderRadius.circular(50.0))),
            //                         onPressed: () {},
            //                         child: Text("Unavailable"),
            //                       ),
            //                     )
            //                   : Container(
            //                       height: 50,
            //                       width: 300,
            //                       child: ElevatedButton(
            //                         style: ElevatedButton.styleFrom(
            //                             backgroundColor:
            //                                 Theme.of(context).primaryColor,
            //                             shape: RoundedRectangleBorder(
            //                                 borderRadius:
            //                                     BorderRadius.circular(50.0))),
            //                         onPressed: () {
            //                           addpart(
            //                               partsList[index]["Partname"],
            //                               partsList[index]["Partprice"] * quant,
            //                               partsList[index]["Partimg"],
            //                               quant);

            //                         },
            //                         child: Text("Add to cart"),
            //                       ),
            //                     )
            //             ],
            //           );
            //         },
            //       ),
          ),
        ],
      ),
    );
  }
}
