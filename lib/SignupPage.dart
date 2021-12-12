// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibble/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

String role = "consumer";
String email = "";
String password = "";
String confirmPass = "";

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firestore = FirebaseFirestore.instance;
  int _canCreateVar = 9;

  void canCreate(String newEmail) {
    _firestore
        .collection("users")
        .where("email", isEqualTo: newEmail)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (result.data().toString().contains(newEmail)) {
          _canCreateVar = 1;
          return;
        } else
          _canCreateVar = 0;
      });
    });
  }

  var segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Consumer"),
    1: Text("Manufacturer"),
    2: Text("Shipper")
  };

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/back.jpg"), fit: BoxFit.fill),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: size.height * 0.07,
                bottom: size.height * 0.07),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hello,",
                          style: GoogleFonts.robotoSlab(
                              letterSpacing: 1,
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(5)),
                        ),
                        Text(
                          "Let's Sign You Up !",
                          style: GoogleFonts.robotoSlab(
                              letterSpacing: 1,
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(4)),
                        ),
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoSlidingSegmentedControl(
                          thumbColor: Colors.blue,
                          groupValue: segmentedControlGroupValue,
                          children: myTabs,
                          onValueChanged: (i) {
                            setState(() {
                              segmentedControlGroupValue =
                                  int.parse(i.toString());
                              if (segmentedControlGroupValue == 0)
                                role = 'consumer';
                              else if (segmentedControlGroupValue == 1)
                                role = 'manufacturer';
                              else
                                role = 'shipper';
                            });
                          }),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: TextField(
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                ),
                              ),
                              prefixIcon: Icon(Icons.account_circle),
                              hintStyle: GoogleFonts.robotoSlab(
                                fontSize: 18,
                              ),
                              hintText: "Email or Username"),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: TextField(
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                ),
                              ),
                              prefixIcon: Icon(Icons.password_rounded),
                              hintStyle: GoogleFonts.robotoSlab(
                                fontSize: 18,
                              ),
                              hintText: "New Password"),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: TextField(
                          onChanged: (value) {
                            confirmPass = value;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                ),
                              ),
                              prefixIcon: Icon(Icons.password_rounded),
                              hintStyle: GoogleFonts.robotoSlab(
                                fontSize: 18,
                              ),
                              hintText: " Confirm Password"),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          if (password == confirmPass) {
                            print(role);
                            _firestore.collection('users').add({
                              'email': email,
                              'password': password,
                              'role': role,
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          } else {
                            Fluttertoast.showToast(
                                msg: "Password  doesn't match",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.green,
                                fontSize: 16.0);
                          }
                        },
                        elevation: 0,
                        padding: EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            "Sign up",
                            style: GoogleFonts.robotoSlab(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: GoogleFonts.robotoSlab(
                              fontSize: 15,
                              color: Color(0xff767676),
                            ),
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: ' Sign in',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                              style: GoogleFonts.robotoSlab(
                                fontSize: 14,
                              ),
                            ),
                          ]))
                        ],
                      ),
                    ],
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
