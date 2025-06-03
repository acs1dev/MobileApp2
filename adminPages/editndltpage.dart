import 'dart:async';
import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/adminPages/addpartspage.dart';
import 'package:graduationpro/designs/themes.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quickalert/quickalert.dart';

class editndltpage extends StatefulWidget {
  var carname;
  var carmodel;
  editndltpage({super.key, required this.carname, required this.carmodel});

  @override
  State<editndltpage> createState() => _editndltpageState();
}

class _editndltpageState extends State<editndltpage> {
  final CollectionReference partsRef =
      FirebaseFirestore.instance.collection("Parts");

  TextEditingController _Part = TextEditingController();
  TextEditingController _Price = TextEditingController();
  TextEditingController _Desc = TextEditingController();
  TextEditingController _Quant = TextEditingController();
  TextEditingController _Carname = TextEditingController();
  TextEditingController _Carmodel = TextEditingController();
  TextEditingController _Parttype = TextEditingController();
  late bool ispopo;
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

  User? user = FirebaseAuth.instance.currentUser;
  delete() {
    FirebaseFirestore.instance.collection("Parts").doc(user!.uid).delete();
  }

  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _Price.text = documentSnapshot["Partprice"].toString();
      _Part.text = documentSnapshot["Partname"];
      _Desc.text = documentSnapshot["Partdesc"];
      _Quant.text = documentSnapshot["Partquant"].toString();
      _Carname.text = documentSnapshot["Carname"];
      _Carmodel.text = documentSnapshot["Carmodel"].toString();
      _Parttype.text = documentSnapshot["Parttype"];
      ispopo = documentSnapshot["IsPopular"];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return Padding(
              padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          height: 200,
                          width: 200,
                          child: Image(
                            image: NetworkImage(documentSnapshot!["Partimg"]),
                          )),
                      Container(
                        height: 150,
                        width: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 28, top: 15),
                              child: IconButton(
                                  onPressed: () {
                                    selectImage()
                                        .then((value) => uploadImage());
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 60,
                                    color: Theme.of(context).primaryColor,
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Change image",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
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
                    child: TextFormField(
                      controller: _Part,
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
                      controller: _Price,
                      decoration: TextBoxDesign().TextInputo("", "", Icons.abc),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: TextFormField(
                      controller: _Desc,
                      decoration: TextBoxDesign().TextInputo("", "", Icons.abc),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: TextFormField(
                      controller: _Parttype,
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
                      controller: _Quant,
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
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ispopo == false
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0))),
                              onPressed: () {
                                setState(() {
                                  ispopo = true;
                                });
                              },
                              child: Text("yes"))
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0))),
                              onPressed: () {
                                setState(() {
                                  ispopo = false;
                                });
                              },
                              child: Text("no"))
                    ],
                  )),
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
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                            final double? price = double.tryParse(_Price.text);
                            final int? model = int.tryParse(_Carmodel.text);
                            final int? quant = int.tryParse(_Quant.text);
                            final String? pic = documentSnapshot["Partimg"];
                            if (price != null &&
                                model != null &&
                                quant != null &&
                                _Part.text != null &&
                                _Carname.text != null &&
                                _Desc.text != null &&
                                _Parttype.text != null) {
                              pickedFile == null
                                  ? await partsRef
                                      .doc(documentSnapshot.id)
                                      .update({
                                      "Carname": _Carname.text,
                                      "Carmodel": model,
                                      "Partname": _Part.text,
                                      "Partprice": price,
                                      "Partdesc": _Desc.text,
                                      "Parttype": _Parttype.text,
                                      "IsPopular": ispopo,
                                      "Partquant": quant,
                                    })
                                  : await showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 300,
                                          width: 300,
                                          child: Center(
                                            child: Column(
                                              children: [
                                                StreamBuilder<TaskSnapshot>(
                                                  stream: uploadTask
                                                      ?.snapshotEvents,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      final data =
                                                          snapshot.data!;
                                                      double progress =
                                                          data.bytesTransferred /
                                                              data.totalBytes;
                                                      return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              CircularPercentIndicator(
                                                                radius: 100,
                                                                percent:
                                                                    progress,
                                                                lineWidth: 15,
                                                                progressColor: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                backgroundColor:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        64,
                                                                        114,
                                                                        155),
                                                                circularStrokeCap:
                                                                    CircularStrokeCap
                                                                        .round,
                                                                center: Text(
                                                                  '${(100 * progress).roundToDouble()}%',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              data.bytesTransferred ==
                                                                      data.totalBytes
                                                                  ? Text(
                                                                      "Updated successfully",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              26,
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    )
                                                                  : Text(
                                                                      "Wait Momentarily",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              26,
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    ),
                                                            ],
                                                          ));
                                                    } else {
                                                      return snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 130),
                                                              child: Center(
                                                                child: Text(
                                                                  "Please Wait Momentarily",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          26,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 130),
                                                              child: Center(
                                                                child: Text(
                                                                  "Updated successfully",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          26,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((value) =>
                                      partsRef.doc(documentSnapshot.id).update({
                                        "Carname": _Carname.text,
                                        "Carmodel": model,
                                        "Partname": _Part.text,
                                        "Partprice": price,
                                        "Partdesc": _Desc.text,
                                        "Parttype": _Parttype.text,
                                        "IsPopular": ispopo,
                                        "Partquant": quant,
                                        "Partimg": urlDownload.toString()
                                      }));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 40,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    Text(
                                      "${documentSnapshot["Partname"]} Updated",
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
                              // _Carname.text = '';
                              // _Carmodel.text = '';
                              // _Part.text = '';
                              // _Price.text = '';
                              // _Desc.text = '';
                              // _Parttype.text = '';
                              // _Quant.text = '';
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
        });
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
                return addpartspage(
                  carname: widget.carname,
                  carmodel: widget.carmodel,
                );
              },
            ));
          },
        ),
      ),
      body: ListView(
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
                  width: 20,
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
                  widget.carname + " Parts",
                  style: TextStyle(
                      fontSize: 23,
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
            height: 535,
            width: 300,
            child: StreamBuilder(
              stream: partsRef
                  .where("Carname", isEqualTo: widget.carname)
                  .snapshots(),
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

                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.network(
                            documentSnapshot["Partimg"],
                            height: 100,
                            width: 100,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: Container(
                                      height: 80,
                                      width: 80,
                                      child:
                                          Lottie.asset("assets/bluecar.json")),
                                );
                              }
                            },
                          ),
                          Text(documentSnapshot["Partname"]),
                          Text(documentSnapshot["Partprice"].toString()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Card(
                                elevation: 20,
                                shadowColor: Color.fromARGB(255, 253, 249, 0),
                                color: Theme.of(context).accentColor,
                                child: IconButton(
                                    onPressed: () {
                                      update(documentSnapshot);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Color.fromARGB(255, 255, 251, 7),
                                      size: 35,
                                    )),
                              ),
                              Card(
                                elevation: 20,
                                shadowColor: Colors.red,
                                color: Theme.of(context).accentColor,
                                child: IconButton(
                                    onPressed: () {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.warning,
                                        animType: QuickAlertAnimType.rotate,
                                        title: "DELETE PART",
                                        text:
                                            "Are you sure you want to delete ${documentSnapshot["Partname"]} ?",
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
                                              .collection("Parts")
                                              .doc(ID)
                                              .delete();
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  size: 40,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                Text(
                                                  "${documentSnapshot["Partname"]} deleted",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      fontSize: 23),
                                                ),
                                              ],
                                            ),
                                            duration: Duration(seconds: 3),
                                            behavior: SnackBarBehavior.floating,
                                            padding: EdgeInsets.all(20),
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                          ));
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 35,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
