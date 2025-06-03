import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/adminPages/editndltpage.dart';
import 'package:lottie/lottie.dart';

class careditpartpage extends StatefulWidget {
  const careditpartpage({super.key});

  @override
  State<careditpartpage> createState() => _careditpartpageState();
}

class _careditpartpageState extends State<careditpartpage> {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Pick car to show the parts",
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
              height: 570,
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
                                return editndltpage(
                                  carname: carsList[index]["Name"],
                                  carmodel: carsList[index]["model"],
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
