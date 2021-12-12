// ignore: file_names
// ignore_for_file: import_of_legacy_library_into_null_safe, must_be_immutable, deprecated_member_use, avoid_unnecessary_containers, avoid_print, annotate_overrides, avoid_function_literals_in_foreach_calls, curly_braces_in_flow_control_structures, file_names, use_key_in_widget_constructors, prefer_const_constructors, unnecessary_new, duplicate_ignore, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibble/ManufacturerPage.dart';
import 'package:fibble/SignupPage.dart';
import 'consumerPage.dart';
import 'package:fibble/shipperpage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class LoginPage extends StatelessWidget {
  String email = "";
  String password = "";
  var result;
  String currentUser = "";
  final _firestore = FirebaseFirestore.instance;

  Future<String> getRole(String email, String id) async {
    var user = _firestore
        .collection('user')
        .where('email', isEqualTo: email)
        .snapshots();
    await for (var u in user) {
      return u.toString();
    }
    return 'none';
  }

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
                          "Hola,",
                          style: GoogleFonts.robotoSlab(
                              letterSpacing: 1,
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(5)),
                        ),
                        Text(
                          "Welcome To D-leet.",
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
                                  color: Colors.transparent,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
                              hintText: "Password"),
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
                        onPressed: () async {
                          _firestore
                              .collection("users")
                              .where("email", isEqualTo: email)
                              .get()
                              .then((querySnapshot) {
                            querySnapshot.docs.forEach((result) {
                              currentUser = result.data().toString();
                              print(result.data());
                            });
                          });
                          if (currentUser.contains('consumer') &&
                              currentUser.contains(password) &&
                              email != '' &&
                              password != '')
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConsumerPage(
                                          uname: email,
                                        )));
                          else if (currentUser.contains('manufacturer') &&
                              currentUser.contains(password) &&
                              email != '' &&
                              password != '')
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ManufacturerPage(
                                          uname: email,
                                        )));
                          else if (currentUser.contains('shipper') &&
                              currentUser.contains(password) &&
                              email != '' &&
                              password != '')
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShipperPage(
                                          uname: email,
                                        )));
                          else {
                            Fluttertoast.showToast(
                                msg: "Wrong Credentials",
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
                            "Login",
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
                            "Don't have an account?",
                            style: GoogleFonts.robotoSlab(
                              fontSize: 15,
                              color: Color(0xff767676),
                            ),
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: ' Register',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignupPage()));
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
