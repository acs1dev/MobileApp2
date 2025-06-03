// ignore_for_file: unused_import, depend_on_referenced_packages, camel_case_types, prefer_const_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace, use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/designs/adminbottombar.dart';
import 'package:intl/intl.dart';

class addappointmentspage extends StatefulWidget {
  const addappointmentspage({super.key});

  @override
  State<addappointmentspage> createState() => _addappointmentspageState();
}

class _addappointmentspageState extends State<addappointmentspage> {
  DateTimeRange dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  int to = 16;
  int from = 6;
  addappointments() async {
    for (int i = 0; i < dateRange.duration.inDays + 1; i++) {
      for (int t = from; t < to; t++) {
        FirebaseFirestore.instance.collection("Appointments").add({
          "Date": dateRange.start.add(Duration(days: i, hours: t)),
          "Reserved": false,
          "Reservationum": null,
          "For": null,
          "Ex": false
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    final difference = dateRange.duration;
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
                  Icon(
                    CupertinoIcons.add_circled,
                    size: 45,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Add Appointments",
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
            height: 80,
          ),
          Text(
            "Press the button below to add new appointments",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 255, bottom: 20),
            child: Text(
              "Time :",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 65,
              ),
              Text("From",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 145,
              ),
              Text("To",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      from > 1 ? from-- : from;
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              Text(
                "${from}",
                style: TextStyle(fontSize: 25),
              ),
              from == 12
                  ? Text("pm", style: TextStyle(fontSize: 25))
                  : Text("am", style: TextStyle(fontSize: 25)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      from < 12 ? from++ : from;
                    });
                  },
                  icon: Icon(Icons.arrow_forward_ios)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      to > 14 ? to-- : to;
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              Text(
                to == 14
                    ? "1 pm"
                    : to == 15
                        ? "2 pm"
                        : to == 16
                            ? "3 pm"
                            : to == 17
                                ? "4 pm"
                                : to == 18
                                    ? "5 pm"
                                    : to == 19
                                        ? "6 pm"
                                        : to == 20
                                            ? "7 pm"
                                            : to == 21
                                                ? "8 pm"
                                                : to == 22
                                                    ? "9 pm"
                                                    : to == 23
                                                        ? "10 pm"
                                                        : "0",
                style: TextStyle(fontSize: 25),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      to < 23 ? to++ : to;
                    });
                  },
                  icon: Icon(Icons.arrow_forward_ios)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 3,
            width: 360,
            color: Theme.of(context).primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 230, top: 20),
            child: Text(
              "Days : ${difference.inDays + 1}",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              SizedBox(
                width: 75,
              ),
              Text("From",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 140,
              ),
              Text("To",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                width: 150,
                alignment: Alignment.center,
                child: Text(
                  "${start.year}/${start.month}/${start.day}",
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 22),
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10))),
              ),
              Container(
                height: 50,
                width: 150,
                alignment: Alignment.center,
                child: Text(
                  "${end.year}/${end.month}/${end.day}",
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 22),
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(20),
                        topLeft: Radius.circular(20))),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 3,
            width: 360,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 35,
          ),
          Container(
            height: 50,
            width: 300,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0))),
                onPressed: () async {
                  DateTimeRange? newDateRange = await showDateRangePicker(
                    context: context,
                    initialDateRange: dateRange,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (newDateRange == null) return;

                  setState(() => dateRange = newDateRange);
                  addappointments();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 40,
                          color: Theme.of(context).accentColor,
                        ),
                        Text(
                          "Dates added successfuly",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 23),
                        ),
                      ],
                    ),
                    duration: Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    padding: EdgeInsets.all(20),
                    backgroundColor: Theme.of(context).primaryColor,
                  ));
                },
                child: Text("Select Date")),
          ),
        ],
      ),
    );
  }

  // DropdownMenuItem<String>buildMenuItem(String item)=>DropdownMenuItem(value: item,child: Text("${item}"),);
  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }
}
