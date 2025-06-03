import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/Log%20&%20Regster/AdminRegister.dart';
import 'package:graduationpro/Log%20&%20Regster/LogIn.dart';
import 'package:graduationpro/adminPages/addappointmentspage.dart';
import 'package:graduationpro/adminPages/edit.dart';
import 'package:graduationpro/adminPages/editads.dart';
import 'package:graduationpro/adminPages/editcustomers.dart';
import 'package:graduationpro/adminPages/editndltappage.dart';
import 'package:graduationpro/adminPages/editndltcustappage.dart';
import 'package:graduationpro/adminPages/editndltpage.dart';
import 'package:graduationpro/adminPages/orderhisntrkpage.dart';
import 'package:graduationpro/designs/adminbottombar.dart';
import 'package:lottie/lottie.dart';

class dashboardpage extends StatefulWidget {
  const dashboardpage({super.key});

  @override
  State<dashboardpage> createState() => _dashboardpageState();
}

class _dashboardpageState extends State<dashboardpage> {
  //cars
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
    print(carsList.length);
  }

  //users
  List usersList = [];
  CollectionReference usersRef = FirebaseFirestore.instance.collection("User");

  Showusers() async {
    var response = await usersRef.where("RoleID", isEqualTo: 1).get();
    response.docs.forEach((element) {
      setState(() {
        usersList.add(element.data());
      });
    });
    print("-------------------------");
    print(usersList.length);
  }

  //admins
  List adminsList = [];
  CollectionReference adminsRef = FirebaseFirestore.instance.collection("User");

  Showadmins() async {
    var response = await adminsRef.where("RoleID", isEqualTo: 2).get();
    response.docs.forEach((element) {
      setState(() {
        adminsList.add(element.data());
      });
    });
    print("-------------------------");
    print(adminsList.length);
  }

  //appointments
  List appList = [];
  CollectionReference appRef =
      FirebaseFirestore.instance.collection("Appointments");

  Showapp() async {
    var response = await appRef.where("Reserved", isEqualTo: false).get();
    response.docs.forEach((element) {
      setState(() {
        appList.add(element.data());
      });
    });
    print("-------------------------");
    print(appList.length);
  }

  //reservation
  List resList = [];
  CollectionReference resRef =
      FirebaseFirestore.instance.collection("Appointments");

  Showres() async {
    var response = await resRef.where("Reserved", isEqualTo: true).get();
    response.docs.forEach((element) {
      setState(() {
        resList.add(element.data());
      });
    });
    print("-------------------------");
    print(resList.length);
  }

  //parts
  List partsList = [];
  CollectionReference partsRef = FirebaseFirestore.instance.collection("Parts");

  Showparts() async {
    var response = await partsRef.get();
    response.docs.forEach((element) {
      setState(() {
        partsList.add(element.data());
      });
    });
    print("-------------------------");
    print(partsList.length);
  }

  //out of stock parts
  List outList = [];
  CollectionReference outRef = FirebaseFirestore.instance.collection("Parts");

  Showoos() async {
    var response = await outRef.where("Partquant", isEqualTo: 0).get();
    response.docs.forEach((element) {
      setState(() {
        outList.add(element.data());
      });
    });
    print("-------------------------");
    print(outList.length);
  }

  //orders
  List ordersList = [];
  CollectionReference ordersRef =
      FirebaseFirestore.instance.collection("orderhistory");

  Showorders() async {
    var response = await ordersRef.get();
    response.docs.forEach((element) {
      setState(() {
        ordersList.add(element.data());
      });
    });
    print("-------------------------");
    print(ordersList.length);
  }

  //ads
  List adsList = [];
  CollectionReference adsRef = FirebaseFirestore.instance.collection("Ads");
  Showads() async {
    var response = await adsRef.get();
    response.docs.forEach((element) {
      setState(() {
        adsList.add(element.data());
      });
    });
    print("-------------------------");
    print(adsList.length);
  }

  Signout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return LogIn();
      },
    ));
  }

  CollectionReference useRef = FirebaseFirestore.instance.collection("User");
  User? user = FirebaseAuth.instance.currentUser;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Showcars();
    Showusers();
    Showadmins();
    Showapp();
    Showres();
    Showparts();
    Showoos();
    Showorders();
    Showads();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                                      return adminbottombar();
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
                                              Icon(
                                                  CupertinoIcons
                                                      .profile_circled,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Users",
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
                                        return editcustomers();
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
                                              Icon(CupertinoIcons.star,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Advertisements",
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
                                        return editads();
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
                                                "Orders",
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
                                        return orderhisntrkpage();
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
                                                      .add_circled_solid,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Register Admin",
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
                                        return AdminRegister();
                                      },
                                    ));
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
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
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Container(
            height: 70,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Icon(
                    Icons.sort_rounded,
                    color: Theme.of(context).accentColor,
                    size: 45,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  "Welcome   ",
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
                  "   Admin",
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            height: 575,
            width: double.infinity,
            child: GridView(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.car_detailed,
                          size: 70,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Number of Cars",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        carsList.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    strokeWidth: 10.0),
                              )
                            : Text(
                                "${carsList.length}",
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return editcustomers();
                      },
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Icon(
                            CupertinoIcons.profile_circled,
                            size: 70,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Users",
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          usersList.isEmpty
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                      strokeWidth: 10.0),
                                )
                              : Text(
                                  "${usersList.length}",
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Icon(
                          CupertinoIcons.person_crop_rectangle_fill,
                          size: 70,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "admins",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        adminsList.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    strokeWidth: 10.0),
                              )
                            : Text(
                                "${adminsList.length}",
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return addappointmentspage();
                      },
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Icon(
                            CupertinoIcons.calendar,
                            size: 70,
                            color: appList.length == 0
                                ? Colors.red
                                : Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Available appointments",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          appList.isEmpty
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                      strokeWidth: 10.0),
                                )
                              : Text(
                                  "${appList.length}",
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return editndltcustappage();
                      },
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Icon(
                            CupertinoIcons.calendar_circle_fill,
                            size: 70,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Reserved appointments",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          resList.isEmpty
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                      strokeWidth: 10.0),
                                )
                              : Text(
                                  "${resList.length}",
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Icon(
                          Icons.handyman_rounded,
                          size: 70,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Parts",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        partsList.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    strokeWidth: 10.0),
                              )
                            : Text(
                                "${partsList.length}",
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return orderhisntrkpage();
                      },
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Icon(
                            CupertinoIcons.time,
                            size: 70,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Orders",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          ordersList.isEmpty
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                      strokeWidth: 10.0),
                                )
                              : Text(
                                  "${ordersList.length}",
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return editads();
                      },
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Icon(
                            Icons.ads_click_rounded,
                            size: 70,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Ads",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          adsList.isEmpty
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                      strokeWidth: 10.0),
                                )
                              : Text(
                                  "${adsList.length}",
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
