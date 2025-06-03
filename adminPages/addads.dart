// ignore_for_file: prefer_const_constructors, unused_import, duplicate_import, camel_case_types, unnecessary_new, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print, deprecated_member_use, sized_box_for_whitespace

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/designs/themes.dart';
import 'package:graduationpro/designs/themes.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class addads extends StatefulWidget {
  const addads({super.key});

  @override
  State<addads> createState() => _addadsState();
}

class _addadsState extends State<addads> {
  GlobalKey<FormState> formState = new GlobalKey<FormState>();
  TextEditingController number = new TextEditingController();
  UploadTask? uploadTask;
  late File file;
  PlatformFile? pickedFile;
  var urlDownload;
  Future uploadImage() async {
    final path = 'ADS/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final Imageref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = Imageref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    urlDownload = await snapshot.ref.getDownloadURL();
    print("Download Link: $urlDownload");
    setState(() {
      uploadTask = null;
    });
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  add() {
    var formData = formState.currentState;
    formData!.save();
    final int? numbers = int.tryParse(number.text);

    FirebaseFirestore.instance
        .collection("Ads")
        .add({"image": urlDownload.toString(), "Number": numbers});
  }

  ClearText() {
    number.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
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
                    SizedBox(
                      width: 5,
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
                      "Add Advertisement",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: formState,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      pickedFile != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 200,
                                  width: 200,
                                  child: Image.file(
                                    File(pickedFile!.path!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          selectImage();
                                        },
                                        icon: Icon(
                                          Icons.refresh,
                                          size: 40,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                    Container(
                                        height: 80,
                                        width: 120,
                                        child: Text(
                                          "Press here to change the image",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                )
                              ],
                            )
                          : Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 3),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    selectImage();
                                  },
                                  icon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo_rounded,
                                        size: 60,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Press here to add an image",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ))),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: number,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return "Enter correct Number";
                          } else {
                            return null;
                          }
                        },
                        decoration: TextBoxDesign().TextInputo(
                            " Enter Advertisement Number ",
                            "Number",
                            Icons.numbers),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 70,
                        width: 250,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0))),
                            onPressed: () {
                              uploadImage().then((value) => add());
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      pickedFile = null;
                                                    });
                                                    ClearText();
                                                  },
                                                  icon: Icon(
                                                    Icons.close_rounded,
                                                    color: Colors.red,
                                                    size: 60,
                                                  ))
                                            ],
                                          ),
                                          StreamBuilder<TaskSnapshot>(
                                            stream: uploadTask?.snapshotEvents,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final data = snapshot.data!;
                                                double progress =
                                                    data.bytesTransferred /
                                                        data.totalBytes;
                                                return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: 80,
                                                      percent: progress,
                                                      lineWidth: 15,
                                                      progressColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                              64, 114, 155),
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      center: Text(
                                                        '${(100 * progress).roundToDouble()}%',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ));
                                              } else {
                                                return const SizedBox(
                                                  height: 50,
                                                );
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "Wait for the upload to complete",
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Text("Add Car")),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}


//  SizedBox(
//                         height: 40,
//                       ),
//                       TextFormField(
//                           controller: name,
//                           validator: (value) {
//                             if (value!.isEmpty ||
//                                 !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
//                               return "Enter correct Name";
//                             } else {
//                               return null;
//                             }
//                           },
//                           decoration: di().TextInput("Add Advertisement Name",
//                               "Add Name", Icons.car_crash_rounded)),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       TextFormField(
//                         controller: number,
//                         validator: (value) {
//                           if (value!.isEmpty ||
//                               !RegExp(r'^[0-9]+$').hasMatch(value)) {
//                             return "Enter correct Phone number";
//                           } else {
//                             return null;
//                           }
//                         },
//                         decoration: di().TextInput(
//                             " Phone ", "Enter Phone Number", Icons.phone),
//                         keyboardType: TextInputType.number,
//                       ),
//                       SizedBox(
//                         height: 40,
//                       ),
//                       Container(
//                           height: 50,
//                           width: 250,
//                           child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Theme.of(context).primaryColor,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(50.0)),
//                               ),
//                               onPressed: () async {
//                                 if (formState.currentState!.validate()) {
//                                   add();
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                           content: Text(
//                                               "Enter currect Information")));
//                                 }
//                               },
//                               child: Text("Add"))),