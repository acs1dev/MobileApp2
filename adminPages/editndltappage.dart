import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/adminPages/addappointmentspage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class editndltappage extends StatefulWidget {
  const editndltappage({super.key});

  @override
  State<editndltappage> createState() => _editndltappageState();
}

class _editndltappageState extends State<editndltappage> {
  DateTime dateTime = DateTime(2023, 5, 30, 5, 30);

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
  Future pickDatenTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      this.dateTime = dateTime;
    });
  }

  addappointments() async {
    FirebaseFirestore.instance.collection("Appointments").add({
      "Date": dateTime,
      "Reserved": false,
    });
  }

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

  delete() {
    FirebaseFirestore.instance.collection("Parts").doc(user!.uid).delete();
  }

  DeleteAll() {
    appRef
        .where("Reserved", isEqualTo: false)
        .get()
        .then((value) => value.docs.forEach((element) {
              appRef.doc(element.id).delete();
            }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Showapp();
  }

  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final mintues = dateTime.minute.toString().padLeft(2, '0');
    return Scaffold(
      floatingActionButton: Container(
        height: 80,
        width: 80,
        child: FloatingActionButton.large(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            CupertinoIcons.add,
            color: Theme.of(context).accentColor,
            size: 60,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return addappointmentspage();
              },
            ));
          },
        ),
      ),
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
                    CupertinoIcons.calendar,
                    size: 45,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Edit & Delete Appointments",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
          ),
          Container(
              height: 500,
              width: double.infinity,
              child: StreamBuilder(
                stream: appRef.where("Reserved", isEqualTo: false).snapshots(),
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
                      var ID = snapshot.data!.docs[index].id;
                      DateTime date = documentSnapshot["Date"].toDate();
                      String time = DateFormat("h:mma").format(date);
                      String day = DateFormat("EEEE").format(date);
                      String da = DateFormat.yMMMd().format(date);

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
                                    color: Theme.of(context).accentColor),
                              ),
                              Text(
                                time,
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Theme.of(context).accentColor),
                              ),
                              Text(
                                day,
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Theme.of(context).accentColor),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 35,
                                      width: 50,
                                      alignment: Alignment.center,
                                      child: InkWell(
                                        onTap: () {
                                          pickDatenTime()
                                              .then((value) => appRef
                                                  .doc(documentSnapshot.id)
                                                  .update({"Date": dateTime}))
                                              .then((value) {
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
                                                    "Date updated successfuly",
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
                                          });
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          size: 45,
                                          color:
                                              Color.fromARGB(210, 255, 251, 0),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                  Container(
                                    height: 35,
                                    width: 50,
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.warning,
                                          animType: QuickAlertAnimType.rotate,
                                          title: "DELETE APPOINTMENT",
                                          text:
                                              "Are you sure you want to delete ${da} ${time} ${day} ?",
                                          cancelBtnText: "NO",
                                          confirmBtnText: "YES",
                                          showCancelBtn: true,
                                          confirmBtnColor:
                                              Theme.of(context).primaryColor,
                                          onCancelBtnTap: () {
                                            Navigator.pop(context);
                                          },
                                          onConfirmBtnTap: () {
                                            FirebaseFirestore.instance
                                                .collection("Appointments")
                                                .doc(ID)
                                                .delete();
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    size: 40,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  Text(
                                                    "Date deleted successfuly",
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
                                              backgroundColor: Color.fromARGB(
                                                  255, 252, 21, 4),
                                            ));
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Color.fromARGB(255, 255, 17, 0),
                                        size: 45,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ],
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: documentSnapshot["Reserved"] == true
                                  ? Color.fromARGB(255, 204, 214, 66)
                                  : Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      );
                    },
                  );
                },
              )),
          Padding(
            padding: const EdgeInsets.only(right: 100, top: 15),
            child: Container(
              height: 50,
              width: 250,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 211, 28, 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0))),
                  onPressed: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      title: "DELETE ALL APPOINTMENTS",
                      text:
                          "Are you sure you want to delete all of the available appointments ?",
                      cancelBtnText: "No",
                      confirmBtnText: "Yes, I'm sure",
                      confirmBtnColor: Color.fromARGB(255, 211, 28, 15),
                      showCancelBtn: true,
                      onCancelBtnTap: () {
                        Navigator.pop(context);
                      },
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: "FINAL WARNING",
                            text:
                                "You are about to delete all available appointments and this procedure can't be undo !",
                            showCancelBtn: true,
                            onCancelBtnTap: () {
                              Navigator.pop(context);
                            },
                            onConfirmBtnTap: () {
                              DeleteAll();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 40,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    Text(
                                      "Dates deleted successfuly",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
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
                              Navigator.pop(context);
                            },
                            confirmBtnText: "Sure",
                            cancelBtnText: "Go back",
                            confirmBtnColor: Color.fromARGB(255, 211, 28, 15));
                      },
                    );
                  },
                  child: Text("DELETE ALL APPOINTMENTS")),
            ),
          ),
        ],
      ),
    );
  }
}
