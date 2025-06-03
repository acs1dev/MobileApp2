// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/designs/themes.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class addcar extends StatefulWidget {
  const addcar({super.key});

  @override
  State<addcar> createState() => _addcarState();
}

class _addcarState extends State<addcar> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;

  GlobalKey<FormState> formState = new GlobalKey<FormState>();
  TextEditingController _Carname = TextEditingController();
  TextEditingController _Carmodel = TextEditingController();

  UploadTask? uploadTask;
  late File file;
  PlatformFile? pickedFile;
  var urlDownload;
  Future uploadImage() async {
    final path = 'Cars/${pickedFile!.name}';
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

  add() async {
    var formData = formState.currentState;
    formData!.save();

    final int? model = int.tryParse(_Carmodel.text);
    FirebaseFirestore.instance.collection("Cars").add({
      'Name': _Carname.text,
      "image": urlDownload.toString(),
      "model": model,
      "ispop": ispop,
    });
  }

  void ClearText() {
    _Carmodel.clear();
    _Carname.clear();
  }

  delete() {
    var formData = formstate.currentState;
    formData!.save();
    FirebaseFirestore.instance.collection("Cars").doc(user!.uid).delete();
  }

  late bool ispop = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                    "Add Cars",
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
                                        "change image",
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
                                      "add image",
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
                    TextFormField(
                        controller: _Carname,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                            return "Enter correct Name";
                          } else {
                            return null;
                          }
                        },
                        decoration: TextBoxDesign().TextInputo("Enter car name",
                            "car name", Icons.car_crash_rounded)),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: _Carmodel,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return "Enter correct Name";
                        } else {
                          return null;
                        }
                      },
                      decoration: TextBoxDesign().TextInputo(
                          "Enter car model", "car model", Icons.numbers),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Text(
                          " Is popular ?",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 32,
                        ),
                        Text(
                          "Yes",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 17,
                        ),
                        Radio(
                          value: true,
                          activeColor: Theme.of(context).primaryColor,
                          groupValue: ispop,
                          onChanged: (value) {
                            setState(() {
                              ispop = true;
                            });
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "No",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 43,
                        ),
                        Radio(
                          value: false,
                          activeColor: Theme.of(context).primaryColor,
                          groupValue: ispop,
                          onChanged: (value) {
                            setState(() {
                              ispop = false;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
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
                                    height: MediaQuery.of(context).size.height *
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
                                                    ispop = false;
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
                                        SizedBox(
                                          height: 40,
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
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      CircularPercentIndicator(
                                                    radius: 80,
                                                    percent: progress,
                                                    lineWidth: 15,
                                                    progressColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 64, 114, 155),
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
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
    );
  }
}
