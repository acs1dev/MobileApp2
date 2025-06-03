import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/customerPages/partdetailspage.dart';
import 'package:lottie/lottie.dart';

class partspage extends StatefulWidget {
  var parts;
  var carname;
  partspage({super.key, required this.parts, required this.carname});

  @override
  State<partspage> createState() => _partspageState();
}

class _partspageState extends State<partspage> {
  List partsList = [];
  CollectionReference partsRef = FirebaseFirestore.instance.collection("Parts");
  User? user = FirebaseAuth.instance.currentUser;
  Showparts() async {
    if (widget.parts == "All") {
      var response =
          await partsRef.where("Carname", isEqualTo: widget.carname).get();
      response.docs
        ..forEach((element) {
          setState(() {
            partsList.add(element.data());
          });
        });
      print("-------------------------");
      print(partsList);
    } else {
      var response = await partsRef
          .where("Parttype", isEqualTo: widget.parts)
          .where("Carname", isEqualTo: widget.carname)
          .get();
      response.docs
        ..forEach((element) {
          setState(() {
            partsList.add(element.data());
          });
        });
      print("-------------------------");
      print(partsList);
    }
  }

  List cartList = [];
  CollectionReference cartRef = FirebaseFirestore.instance.collection("Parts");
  ShowCart() async {
    var response = await cartRef.get();
    response.docs
      ..forEach((element) {
        setState(() {
          cartList.add(element.data());
        });
      });
    print("-------------------------");
    print(cartList);
  }

  addpart(String prtname, double price, String img) async {
    FirebaseFirestore.instance.collection("Cart").add({
      "PartName": prtname,
      "Price": price,
      "Image": img,
      "Quantity": 1,
      "Useruid": user!.uid
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Showparts();
    ShowCart();
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
                  width: 90,
                ),
                Text(
                  widget.parts,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Container(
              height: 600,
              child: partsList.isEmpty || partsList == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/bluecar.json"),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Loading....",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: partsList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return partdetailspage(
                                  partname: partsList[index]["Partname"],
                                  carname: partsList[index]["Carname"],
                                );
                              },
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 250,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        // image: DecorationImage(
                                        //     image: NetworkImage(
                                        //         partsList[index]["Partimg"]),
                                        //     fit: BoxFit.contain),
                                        borderRadius:
                                            BorderRadius.circular(60)),
                                    child: Image.network(
                                      partsList[index]["Partimg"],
                                      fit: BoxFit.contain,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: Lottie.asset(
                                                "assets/bluecar.json"),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Text(
                                    partsList[index]["Partname"],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                          partsList[index]["Partprice"]
                                                  .toString() +
                                              " SR",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .primaryColor)),

                                      // partsList[index]["Partquant"] == 0
                                      //     ? InkWell(
                                      //       onTap: () {

                                      //       },
                                      //       child: Icon(
                                      //           CupertinoIcons.cart_badge_minus,
                                      //           color: Colors.red,
                                      //           size: 30,
                                      //         ),
                                      //     )
                                      //     : InkWell(
                                      //       onTap: () {
                                      //         addpart(partsList[index]["Partname"], partsList[index]["Partprice"], partsList[index]["Partimg"]);
                                      //       },
                                      //       child: Icon(
                                      //           CupertinoIcons.cart,
                                      //           color:
                                      //               Theme.of(context).primaryColor,
                                      //           size: 30,
                                      //         ),
                                      //     ),
                                    ],
                                  ),
                                  partsList[index]["Partquant"] == 3 ||
                                          partsList[index]["Partquant"] == 2 ||
                                          partsList[index]["Partquant"] == 1
                                      ? Text(
                                          "only " +
                                              partsList[index]["Partquant"]
                                                  .toString() +
                                              " left",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 18),
                                        )
                                      : partsList[index]["Partquant"] == 0
                                          ? Text(
                                              "Unavailable",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18),
                                            )
                                          : Center()
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
        ],
      ),
    );
  }
}
