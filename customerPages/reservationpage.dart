import 'dart:math';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/customerPages/viewpage.dart';
import 'package:graduationpro/designs/bottombar.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';

class reservationpage extends StatefulWidget {
  const reservationpage({super.key});

  @override
  State<reservationpage> createState() => _reservationpageState();
}

class _reservationpageState extends State<reservationpage> {
  List appList = [];
  CollectionReference appRef =
      FirebaseFirestore.instance.collection("Appointments");
  User? user = FirebaseAuth.instance.currentUser;
  Showapp() async {
    var response = await appRef.get();
    response.docs.forEach((element) {
      setState(() {
        appList.add(element.data());
      });
    });
    print("-------------------------");
    print(appList);
  }

  int resnum = Random().nextInt(11111) + 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Showapp();
    appRef
        .where("Date", isLessThan: DateTime.now())
        .get()
        .then((value) => value.docs.forEach((element) {
              appRef.doc(element.id).update({"Ex": true});
            }));
    appRef.get().then((value) => value.docs.forEach((element) {
          if (element.get("For") == user!.email && element.get("Ex") == false) {
            showModalBottomSheet(
              context: context,
              enableDrag: false,
              isDismissible: false,
              builder: (context) {
                return Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 330),
                          child: Icon(
                            Icons.info,
                            size: 40,
                            color: Colors.amber,
                          ),
                        ),
                        Text(
                          "Sorry...",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "you already have an up to date reservation",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
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
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return bottombar();
                                  },
                                ));
                              },
                              child: Text("Go Back")),
                        ),
                      ],
                    ));
              },
            );
          }
        }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Container(
              height: 70,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    CupertinoIcons.antenna_radiowaves_left_right,
                    size: 45,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Reserve Appointments",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Reserve from the appointments below",
            style: TextStyle(fontSize: 22),
          ),
          Container(
              height: 470,
              width: double.infinity,
              child: StreamBuilder(
                stream: appRef.where("Ex", isEqualTo: false).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                      var ID = snapshot.data!.docs[index].id;
                      DateTime date = documentSnapshot["Date"].toDate();
                      String time = DateFormat("h:mma").format(date);
                      String da = DateFormat.yMMMd().format(date);
                      String day = DateFormat("EEEE").format(date);

                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 100,
                          width: 100,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                da,
                                style: TextStyle(
                                  fontSize: 23,
                                ),
                              ),
                              Text(
                                time,
                                style: TextStyle(
                                  fontSize: 23,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                day,
                                style: TextStyle(
                                  fontSize: 23,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              documentSnapshot["Reserved"] == true
                                  ? Container(
                                      height: 35,
                                      width: 120,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Reserved",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.info,
                                          animType: QuickAlertAnimType.rotate,
                                          title: "Reservation",
                                          text:
                                              "Are you sure you want to reserve ${da} ${time} on ${day} ?",
                                          cancelBtnText: "NO",
                                          confirmBtnText: "YES",
                                          showCancelBtn: true,
                                          confirmBtnColor:
                                              Theme.of(context).primaryColor,
                                          onCancelBtnTap: () {
                                            Navigator.pop(context);
                                          },
                                          onConfirmBtnTap: () {
                                            appRef
                                                .doc(documentSnapshot.id)
                                                .update({
                                              "Reserved": true,
                                              "For": user!.email,
                                              "Reservationum": "#$resnum",
                                            });
                                            Navigator.pop(context);
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return viewpage();
                                              },
                                            ));
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
                                                    "Reserved successfully",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        fontSize: 23),
                                                  ),
                                                ],
                                              ),
                                              duration: Duration(seconds: 3),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              padding: EdgeInsets.all(20),
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                            ));
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 120,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Reserve",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                    )
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: documentSnapshot["Reserved"] == true
                                  ? Colors.amber
                                  : Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      );
                    },
                  );
                },
              )),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Available",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue),
              ),
              Text(
                "Reserved",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.amber),
              ),
            ],
          )
        ],
      ),
    );
  }
}
