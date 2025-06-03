// ignore_for_file: unnecessary_import, unused_import, depend_on_referenced_packages, camel_case_types, unnecessary_new, prefer_final_fields, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, prefer_const_constructors, deprecated_member_use, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/designs/themes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:percent_indicator/circular_percent_indicator.dart';

class addpartspage extends StatefulWidget {
  var carname;
  var carmodel;
  addpartspage({super.key, required this.carname, required this.carmodel});

  @override
  State<addpartspage> createState() => _addpartspageState();
}

class _addpartspageState extends State<addpartspage> {
  GlobalKey<FormState> formState = new GlobalKey<FormState>();
  TextEditingController _Part = TextEditingController();
  TextEditingController _Price = TextEditingController();
  TextEditingController _Desc = TextEditingController();
  TextEditingController _Quant = TextEditingController();
  TextEditingController _Carname = TextEditingController();
  TextEditingController _Carmodel = TextEditingController();

  UploadTask? uploadTask;
  late File file;
  PlatformFile? pickedFile;
  var urlDownload;
  Future uploadImage() async {
    final path = 'Parts/${pickedFile!.name}';
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

  addparts() async {
    var formData = formState.currentState;
    formData!.save();
    final double? price = double.tryParse(_Price.text);
    final int? quant = int.tryParse(_Quant.text);
    final int? model = int.tryParse(_Carmodel.text);
    FirebaseFirestore.instance.collection("Parts").add({
      "Partname": _Part.text,
      "Partprice": price,
      "Partdesc": _Desc.text,
      "Partquant": quant,
      "Carname": _Carname.text,
      "Carmodel": model,
      "Parttype": type,
      "IsPopular": ispop,
      "Partimg": urlDownload.toString(),
      "Partid": ""
    });
  }

  void ClearText() {
    _Carmodel.clear();
    _Carname.clear();
    _Desc.clear();
    _Part.clear();
    _Price.clear();
    _Quant.clear();
  }

  late bool ispop = false;
  var type;
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
                    width: 60,
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
                    "Add parts",
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 27, bottom: 10),
                                    child: IconButton(
                                        onPressed: () {
                                          selectImage();
                                        },
                                        icon: Icon(
                                          Icons.refresh,
                                          size: 60,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                  ),
                                  Container(
                                      height: 80,
                                      width: 120,
                                      child: Text(
                                        "change image",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ))
                                ],
                              )
                            ],
                          )
                        : Container(
                            height: 180,
                            width: 180,
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ))),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                        controller: _Carname..text = widget.carname,
                        decoration: TextBoxDesign().TextInputo("Enter car name",
                            "car name", Icons.car_crash_rounded),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter the car name";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                        controller: _Carmodel
                          ..text = widget.carmodel.toString(),
                        decoration: TextBoxDesign().TextInputo(
                            "Enter car model", "car model", Icons.numbers),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter the car model";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                        controller: _Part,
                        decoration: TextBoxDesign().TextInputo(
                            "Enter part name",
                            "part name",
                            Icons.workspaces_filled),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter the part name";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                        controller: _Desc,
                        decoration: TextBoxDesign().TextInputo(
                            "Enter part description",
                            "part description",
                            Icons.message),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter the part description";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                        controller: _Price,
                        decoration: TextBoxDesign().TextInputo(
                            "Enter part price",
                            "part price",
                            Icons.monetization_on),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter the part price";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                        controller: _Quant,
                        decoration: TextBoxDesign().TextInputo(
                            "Enter quantity of the part",
                            "part quantity",
                            Icons.format_list_numbered),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter the part quantity";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "What type ?",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Text(
                          "Mechanic",
                          style: TextStyle(fontSize: 20),
                        ),
                        Radio(
                          value: "Mechanical",
                          activeColor: Theme.of(context).primaryColor,
                          groupValue: type,
                          onChanged: (value) {
                            setState(() {
                              type = value;
                            });
                          },
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "Body",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Radio(
                          value: "Body",
                          activeColor: Theme.of(context).primaryColor,
                          groupValue: type,
                          onChanged: (value) {
                            setState(() {
                              type = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          " Is popular ?",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Yes",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 54,
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
                          width: 25,
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
                      height: 40,
                    ),
                    Container(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0))),
                          onPressed: () {
                            uploadImage().then((value) => addparts());
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
                                                  pickedFile != null
                                                      ? ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                          content: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .check_circle,
                                                                size: 40,
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor,
                                                              ),
                                                              Text(
                                                                "Part added successfuly",
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .accentColor,
                                                                    fontSize:
                                                                        23),
                                                              ),
                                                            ],
                                                          ),
                                                          duration: Duration(
                                                              seconds: 3),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ))
                                                      : ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                          content: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Icon(
                                                                Icons.info,
                                                                size: 40,
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor,
                                                              ),
                                                              Text(
                                                                "Upload uncomplete",
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .accentColor,
                                                                    fontSize:
                                                                        23),
                                                              ),
                                                            ],
                                                          ),
                                                          duration: Duration(
                                                              seconds: 3),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ));
                                                  setState(() {
                                                    pickedFile = null;
                                                  });
                                                  ClearText();
                                                  setState(() {
                                                    type = null;
                                                    ispop = false;
                                                  });
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
                                                  child: Column(
                                                    children: [
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
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      data.bytesTransferred ==
                                                              data.totalBytes
                                                          ? Text(
                                                              "Part added successfully",
                                                              style: TextStyle(
                                                                  fontSize: 26,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            )
                                                          : Text(
                                                              "Wait Momentarily",
                                                              style: TextStyle(
                                                                  fontSize: 26,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                    ],
                                                  ));
                                            } else {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 120),
                                                child: Center(
                                                  child: Text(
                                                    "Please Wait Momentarily",
                                                    style: TextStyle(
                                                        fontSize: 26,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Text("Add part")),
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
