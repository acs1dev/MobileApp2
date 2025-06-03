import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/customerPages/partdetailspage.dart';
import 'package:lottie/lottie.dart';

class popartspage extends StatefulWidget {
  const popartspage({super.key});

  @override
  State<popartspage> createState() => _popartspageState();
}

class _popartspageState extends State<popartspage> {
  CollectionReference partsRef = FirebaseFirestore.instance.collection("Parts");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Container(
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
                    "Popular Parts",
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 650,
            child: StreamBuilder(
              stream: partsRef.where("IsPopular", isEqualTo: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Column(
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
                  );
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return partdetailspage(
                              partname: documentSnapshot["Partname"],
                              carname: documentSnapshot["Carname"],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    // image: DecorationImage(
                                    //     image: NetworkImage(
                                    //         documentSnapshot["Partimg"]),
                                    //     fit: BoxFit.contain),
                                    borderRadius: BorderRadius.circular(60)),
                                child: Image.network(
                                  documentSnapshot["Partimg"],
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child:
                                            Lottie.asset("assets/bluecar.json"),
                                      );
                                    }
                                  },
                                ),
                              ),
                              Text(
                                documentSnapshot["Partname"],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                      documentSnapshot["Partprice"].toString() +
                                          " SR",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Theme.of(context).primaryColor)),

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
                              documentSnapshot["Partquant"] == 3 ||
                                      documentSnapshot["Partquant"] == 2 ||
                                      documentSnapshot["Partquant"] == 1
                                  ? Text(
                                      "only " +
                                          documentSnapshot["Partquant"]
                                              .toString() +
                                          " left",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18),
                                    )
                                  : documentSnapshot["Partquant"] == 0
                                      ? Text(
                                          "Unavailable",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 18),
                                        )
                                      : Center()
                            ],
                          ),
                        ),
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
