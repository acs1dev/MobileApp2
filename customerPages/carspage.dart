import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/Log%20&%20Regster/LogIn.dart';
import 'package:graduationpro/customerPages/partypepage.dart';
import 'package:lottie/lottie.dart';

class carspage extends StatefulWidget {
  const carspage({super.key});

  @override
  State<carspage> createState() => _carspageState();
}

class _carspageState extends State<carspage> {
  List carsList = [];
  CollectionReference carsRef = FirebaseFirestore.instance.collection("Cars");

  Showcars() async {
    var response = await carsRef.get();
    response.docs.forEach((element) {
      setState(() {
        carsList.add(element.data());
      });
    });
    print("-------------------------");
    print(carsList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Showcars();
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
                  "Pick your car below",
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
              child: carsList.isEmpty
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
                      itemCount: carsList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return partypepage(
                                  carname: carsList[index]["Name"],
                                );
                              },
                            ));
                          },
                          child: Container(
                            height: 200,
                            width: 200,
                            child: Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 180,
                                  decoration: BoxDecoration(
                                      // image: DecorationImage(
                                      //     image: NetworkImage(
                                      //         carsList[index]["image"])),
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white),
                                  child: Image.network(
                                    carsList[index]["image"],
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
                                Container(
                                  height: 30,
                                  width: 150,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    carsList[index]["Name"],
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ))
        ],
      ),
    );
  }
}
