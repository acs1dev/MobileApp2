// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/designs/themes.dart';
import 'package:graduationpro/adminpages/addcar.dart';
import 'package:graduationpro/designs/themes.dart';

class edit extends StatefulWidget {
  const edit({super.key});

  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  final CollectionReference carsRef =
      FirebaseFirestore.instance.collection("Cars");
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController _Carname = TextEditingController();
  TextEditingController _Carmodel = TextEditingController();
  TextEditingController _IsPop = TextEditingController();

  PlatformFile? pickedFile;
  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  late bool ispop;
  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _Carname.text = documentSnapshot["Name"];
      _Carmodel.text = documentSnapshot["model"].toString();
      ispop = documentSnapshot["ispop"];
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
                                selectImage();
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
                  height: 30,
                ),
                Container(
                  child: TextFormField(
                    controller: _Carname,
                    decoration: TextBoxDesign().TextInputo("", "", Icons.abc),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextFormField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: _Carmodel,
                    decoration: TextBoxDesign().TextInputo("", "", Icons.abc),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    child: Row(
                  children: [
                    Text(
                      " Is popular ?",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    ispop == false
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0))),
                            onPressed: () {
                              setState(() {
                                ispop = true;
                              });
                            },
                            child: Text("yes"))
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0))),
                            onPressed: () {
                              setState(() {
                                ispop = false;
                              });
                            },
                            child: Text("no"))
                  ],
                )),
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
                          final int? model = int.tryParse(_Carmodel.text);
                          if (model != null && _Carname.text != null) {
                            await carsRef.doc(documentSnapshot.id).update({
                              "Name": _Carname.text,
                              "model": model,
                              "ispop": ispop,
                            });

                            _Carname.text = '';
                            _Carmodel.text = '';
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

  delete() {
    FirebaseFirestore.instance.collection("Cars").doc(user!.uid).delete();
  }

  @override
  Widget build(BuildContext context) {
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
                return addcar();
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
                Icon(
                  Icons.edit,
                  size: 45,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Edit & Delete Cars",
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
            height: 480,
            width: 300,
            child: StreamBuilder(
              stream: carsRef.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Center();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    var ID = snapshot.data!.docs[index].id;

                    return Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: NetworkImage(documentSnapshot["image"]),
                            height: 100,
                            width: 100,
                          ),
                          Text(documentSnapshot["Name"]),
                          Text(documentSnapshot["model"].toString()),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  update(documentSnapshot);
                                });
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                // var ID = snapshot.data!.docs[index].id;
                                FirebaseFirestore.instance
                                    .collection("Cars")
                                    .doc(ID)
                                    .delete();
                              },
                              icon: Icon(Icons.delete))
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
