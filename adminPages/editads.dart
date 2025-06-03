// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/designs/themes.dart';
import 'package:graduationpro/adminPages/addads.dart';
import 'package:graduationpro/designs/themes.dart';

class editads extends StatefulWidget {
  const editads({super.key});

  @override
  State<editads> createState() => _editadsState();
}

class _editadsState extends State<editads> {
  final CollectionReference carsRef =
      FirebaseFirestore.instance.collection("Ads");
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController number = new TextEditingController();

  late bool ispopo;
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

  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      number.text = documentSnapshot["Number"].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: const EdgeInsets.only(top: 90),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: NetworkImage(documentSnapshot!["image"]),
                      height: 150,
                      width: 150,
                    ),
                    Container(
                      height: 150,
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                selectImage().then((value) => uploadImage());
                              },
                              icon: Icon(
                                Icons.refresh,
                                size: 50,
                                color: Theme.of(context).primaryColor,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Click here to change the image",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextFormField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: number,
                    decoration: TextBoxDesign().TextInputo("", "", Icons.abc),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            "Cancel".toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            "Update".toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          final int? model = int.tryParse(number.text);
                          if (model != null && number.text != null) {
                            await carsRef.doc(documentSnapshot.id).update({
                              "Number": model,
                              "image": urlDownload.toString()
                            });

                            number.text = '';

                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 60,
        width: 60,
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
                return addads();
              },
            ));
          },
        ),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Container(
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
                  width: 15,
                ),
                Icon(
                  Icons.edit,
                  size: 45,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Edit & Delete Ads",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            height: 735,
            width: 300,
            child: StreamBuilder(
              stream: carsRef.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Center();
                }
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    var ID = snapshot.data!.docs[index].id;
                    return Card(
                      borderOnForeground: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: Theme.of(context).primaryColorDark),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: NetworkImage(documentSnapshot["image"]),
                            height: 100,
                            width: 100,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(documentSnapshot["Number"].toString()),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  borderOnForeground: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          update(documentSnapshot);
                                        });
                                      },
                                      icon: Icon(Icons.edit)),
                                ),
                                Card(
                                  borderOnForeground: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        // var ID = snapshot.data!.docs[index].id;
                                        FirebaseFirestore.instance
                                            .collection("Ads")
                                            .doc(ID)
                                            .delete();
                                      },
                                      icon: Icon(Icons.delete)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      )),
    );
  }
}
