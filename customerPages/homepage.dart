import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/Log%20&%20Regster/LogIn.dart';
import 'package:graduationpro/customerPages/carspage.dart';
import 'package:graduationpro/customerPages/cartpage.dart';
import 'package:graduationpro/customerPages/orderhistorypage.dart';
import 'package:graduationpro/customerPages/popartspage.dart';
import 'package:graduationpro/customerPages/profile.dart';
import 'package:graduationpro/customerPages/viewpage.dart';
import 'package:graduationpro/designs/bottombar.dart';
import 'package:graduationpro/designs/header.dart';
import 'package:lottie/lottie.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List carlist = [];
  List partlist = [];
  List adslist = [];
  CollectionReference carsRef = FirebaseFirestore.instance.collection("Cars");
  CollectionReference partsRef = FirebaseFirestore.instance.collection("Parts");
  CollectionReference adsRef = FirebaseFirestore.instance.collection("Ads");

  List aaList = [];
  CollectionReference useRef = FirebaseFirestore.instance.collection("User");
  User? user = FirebaseAuth.instance.currentUser;
  show() async {
    var response = await useRef.where("email", isEqualTo: user!.email).get();
    response.docs.forEach((element) {
      setState(() {
        aaList.add(element.data());
      });
    });
  }

  Signout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return LogIn();
      },
    ));
  }

  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection("User")
        .doc(user!.uid)
        .set({"token": token}, SetOptions(merge: true));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    show();
    storeNotificationToken();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: SafeArea(
            child: StreamBuilder(
              stream: useRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data!.docs[index]["email"] == user!.email) {
                        return Container(
                          height: 840,
                          decoration: BoxDecoration(
                              gradient: new LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Color.fromARGB(255, 25, 27, 77)
                            ],
                          )),
                          child: ListView(
                            children: [
                              Center(
                                child: Container(
                                    height: 230,
                                    width: 250,
                                    child: Image(
                                      image: AssetImage("images/Logo.png"),
                                      height: 180,
                                      width: 200,
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  "Hey, " + snapshot.data!.docs[index]["Name"],
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 50,
                                    child: Card(
                                      color: Theme.of(context).primaryColor,
                                      borderOnForeground: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.home,
                                                color: Colors.white),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Home",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return bottombar();
                                    },
                                  ));
                                },
                              ),
                              InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      height: 50,
                                      child: Card(
                                        color: Theme.of(context).primaryColor,
                                        borderOnForeground: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Icon(CupertinoIcons.calendar,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "My Appointments",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return viewpage();
                                      },
                                    ));
                                  }),
                              InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      height: 50,
                                      child: Card(
                                        color: Theme.of(context).primaryColor,
                                        borderOnForeground: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                  CupertinoIcons
                                                      .profile_circled,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Edit Profile",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return profile();
                                      },
                                    ));
                                  }),
                              InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      height: 50,
                                      child: Card(
                                        color: Theme.of(context).primaryColor,
                                        borderOnForeground: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Icon(CupertinoIcons.time,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Order History",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return orderhistorypage();
                                      },
                                    ));
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(top: 55),
                                child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        height: 50,
                                        child: Card(
                                          color: Theme.of(context).primaryColor,
                                          borderOnForeground: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.logout,
                                                    color: Colors.red),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Signout();
                                    }),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: 70,
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.sort_rounded,
                      color: Theme.of(context).accentColor,
                      size: 40,
                    )),
                SizedBox(
                  width: 45,
                ),
                Text(
                  "Car   ",
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  CupertinoIcons.car_detailed,
                  size: 55,
                  color: Theme.of(context).accentColor,
                ),
                Text(
                  "   Perfection",
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                ),
                // Image(image: AssetImage("images/Logo.png"),height: 120,width: 130,)
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 200,
            child: StreamBuilder(
              stream: adsRef.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: Lottie.asset("assets/bluecar.json"),
                  );
                }
                return CarouselSlider.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index, realIndex) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      return Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(documentSnapshot["image"]),
                                fit: BoxFit.cover)),
                      );
                    },
                    options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true));
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Cars",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return carspage();
                      },
                    ));
                  },
                  child: Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: Text(
                      "View All",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 120,
              width: double.infinity,
              child: StreamBuilder(
                stream: carsRef.where("ispop", isEqualTo: true).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: Lottie.asset("assets/bluecar.json"),
                    );
                  }
                  return CarouselSlider.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index, realIndex) {
                        final DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        return Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                      NetworkImage(documentSnapshot["image"]),
                                  fit: BoxFit.contain),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5),
                              color: Colors.white),
                        );
                      },
                      options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 2.0,
                          viewportFraction: 0.34));
                },
              )),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Parts",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return popartspage();
                      },
                    ));
                  },
                  child: Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: Text(
                      "View All",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 120,
              child: StreamBuilder(
                stream:
                    partsRef.where("IsPopular", isEqualTo: true).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: Lottie.asset("assets/bluecar.json"),
                    );
                  }
                  return CarouselSlider.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index, realIndex) {
                        final DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        return Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                      NetworkImage(documentSnapshot["Partimg"]),
                                  fit: BoxFit.contain),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5),
                              color: Colors.white),
                        );
                      },
                      options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 2.0,
                          viewportFraction: 0.34));
                },
              )),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
