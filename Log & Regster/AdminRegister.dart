import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:gradpro/Adminhome.dart';
import 'package:graduationpro/designs/themes.dart';
import 'package:graduationpro/Log%20&%20Regster/verifiy.dart';
import 'package:graduationpro/designs/adminbottombar.dart';
// import 'package:gradpro/homepage.dart';

class AdminRegister extends StatefulWidget {
  const AdminRegister({super.key});

  @override
  State<AdminRegister> createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {
  var emailAddress, password, phone, fullname;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  add() {
    var formData = formstate.currentState;
    formData!.save();
    FirebaseFirestore.instance.collection("User").add({
      "Name": fullname,
      "email": emailAddress,
      "Phone": phone,
      "password": password,
      "RoleID": 2
      //'userID':user1!.uid
    });
    print(fullname);
  }

  reg() async {
    var formData = formstate.currentState;
    formData!.save();

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          )
          .then((value) => FirebaseFirestore.instance
                  .collection("User")
                  .doc(value.user?.uid)
                  .set({
                "email": value.user?.email,
                "Name": fullname,
                "Phone": phone,
                "password": password,
                "RoleID": 2
              }))
          .then((value) => Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return verifiy();
                },
              )));
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return adminbottombar();
        },
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Form(
            autovalidateMode: AutovalidateMode.always,
            key: formstate,
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Image(
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/graduationproject-5cb91.appspot.com/o/logo%2Fprologo.png?alt=media&token=b8d470bc-510e-40b2-9140-77b06c3c0674"),
                    height: 270,
                  ),
                  Center(
                    child: Container(
                      height: 100,
                      child: Center(
                          child: Text(
                        "Welcome ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 20, bottom: 10),
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        border: Border(),
                        borderRadius: BorderRadius.circular(30),
                        // color: Color.fromRGBO(150, 150, 157, 0.1)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 15),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                              return "Enter correct Name";
                            } else {
                              return null;
                            }
                          },
                          controller: name,
                          onSaved: (newValue) {
                            fullname = newValue;
                          },
                          decoration: TextBoxDesign().TextInputo(
                              "Name", "Enter Full Name", Icons.person),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 20, bottom: 10),
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        border: Border(),
                        borderRadius: BorderRadius.circular(30),
                        // color: Color.fromRGBO(150, 150, 157, 0.1)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 15),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^[\w-\@\.]+$').hasMatch(value)) {
                              return "Enter email";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            emailAddress = newValue;
                          },
                          decoration: TextBoxDesign()
                              .TextInputo("Email", "Enter Email", Icons.mail),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 20, bottom: 10),
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        border: Border(),
                        borderRadius: BorderRadius.circular(30),
                        // color: Color.fromRGBO(150, 150, 157, 0.1)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 15),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return "Enter correct Phone number";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            phone = newValue;
                          },
                          decoration: TextBoxDesign().TextInputo(
                              " Phone ", "Enter Phone Number", Icons.phone),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 20, bottom: 10),
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        border: Border(),
                        borderRadius: BorderRadius.circular(30),
                        // color: Color.fromRGBO(150, 150, 157, 0.1)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 15),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            password = newValue;
                          },
                          decoration: TextBoxDesign().TextInputo(
                              "Password", "Enter Password", Icons.key),
                          obscureText: true,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                          ),
                          onPressed: () {
                            if (formstate.currentState!.validate()) {
                              //final SnackBar = SnackBar(content: Text("Registerd "));
                              reg();
                            } else {
                              return null;
                            }
                          },
                          child: Text("Register"))),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
