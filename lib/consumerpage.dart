// ignore: file_names
// ignore: file_names
// ignore_for_file: import_of_legacy_library_into_null_safe, unused_local_variable, unnecessary_null_comparison, must_be_immutable, camel_case_types, non_constant_identifier_names, duplicate_ignore, annotate_overrides, avoid_print, prefer_const_constructors, prefer_typing_uninitialized_variables, sized_box_for_whitespace, file_names, use_key_in_widget_constructors

import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'smartcontract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'LoginPage.dart';

late String barcode;

class ConsumerPage extends StatelessWidget {
  final String uname;
  const ConsumerPage({required this.uname});

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ProgressHUD(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/back.jpg"), fit: BoxFit.fill),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        uname,
                        style: GoogleFonts.robotoSlab(
                            fontWeight: FontWeight.w100,
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.6)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          height: 30,
                          child: GestureDetector(
                            onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage())),
                            child: GlowIcon(
                              Icons.power_settings_new,
                              glowColor: Color(0xFF40D0FD),
                              size: 24,
                              blurRadius: 10,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  flex: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Did you know?",
                          style: GoogleFonts.robotoSlab(
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(4)),
                        ),
                        Text(
                          "\nWalmart uses blockchain to keep track of its pork it sources from China and the blockchain records where each piece of meat came from, processed, stored and its sell-by-date.",
                          style: GoogleFonts.robotoSlab(
                              letterSpacing: 1,
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2)),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: Lottie.asset('assets/block.json'),
                          ),
                        )
                      ],
                    ),
                  ),
                  flex: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 100,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        scanQR('Scan QR'),
                        SizedBox(
                          height: 20,
                        ),
                        FetchDetails('Fetch Product Info'),
                      ],
                    ),
                  ),
                  flex: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class scanQR extends StatelessWidget {
  final txt;

  const scanQR(this.txt);

  Future _scan() async {
    await Permission.camera.request();
    barcode = (await scanner.scan())!;
  }

  String scannedCondition() {
    if (barcode == null) {
      return "Couldn't Scan Item";
    } else
      // ignore: curly_braces_in_flow_control_structures
      return "Item Scanned Successfully";
  }

  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      onPressed: () async => {
        await _scan(),
        print(barcode),
        Fluttertoast.showToast(
            msg: scannedCondition(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.green,
            fontSize: 16.0)
      },
      elevation: 5,
      // ignore: prefer_const_constructors
      padding: EdgeInsets.all(18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Center(
          child: Text(txt,
              style: GoogleFonts.robotoSlab(
                  fontSize: 18, fontWeight: FontWeight.bold))),
    );
  }
}

class FetchDetails extends StatelessWidget {
  final String txt;
  List<String> allData = [];

  FetchDetails(this.txt);

  late int pd;
  late String status;
  late SmartContract ethHelper;

  Future INIT() async {
    ethHelper = SmartContract();
    int pd = int.parse(barcode);
    status = await ethHelper.getState(pd);
    // ignore: avoid_print
    print(status);
    allData = await ethHelper.getFormattedData(pd);
  }
  // ignore: non_constant_identifier_names

  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    var progress = ProgressHUD.of(context);
    final Size size = MediaQuery.of(context).size;
    // ignore: deprecated_member_use
    return RaisedButton(
      onPressed: () async => {
        progress?.show(),
        progress!.showWithText('Loading...'),
        Future.delayed(Duration(seconds: 3), () {
          progress.dismiss();
        }),
        await INIT(),
        AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          borderSide: BorderSide(color: Colors.white, width: 2),
          width: size.width * 0.95,
          buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
          headerAnimationLoop: true,
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Product Info",
                      style: GoogleFonts.robotoSlab(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Product Name :\n${SmartContract.allData[0]}",
                  style: GoogleFonts.robotoSlab(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Manufactured by :\n${SmartContract.allData[1]}",
                  style: GoogleFonts.robotoSlab(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Manufactured on :${SmartContract.allData[2]}",
                  style: GoogleFonts.robotoSlab(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Product Details :${SmartContract.allData[3]}",
                  style: GoogleFonts.robotoSlab(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Last Location :${SmartContract.allData[4]}",
                  style: GoogleFonts.robotoSlab(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Product Status : ",
                      style: GoogleFonts.robotoSlab(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      (status.compareTo("0") == 0) ? "Manufactured" : "Shipped",
                      style: GoogleFonts.robotoSlab(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          animType: AnimType.BOTTOMSLIDE,
          showCloseIcon: true,
        )..show()
      },
      elevation: 5,
      padding: EdgeInsets.all(18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Center(
          child: Text(txt,
              style: GoogleFonts.robotoSlab(
                  fontSize: 18, fontWeight: FontWeight.bold))),
    );
  }
}
