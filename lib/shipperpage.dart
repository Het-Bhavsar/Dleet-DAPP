// ignore_for_file: import_of_legacy_library_into_null_safe, unused_local_variable, unnecessary_null_comparison, camel_case_types, must_be_immutable, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors, sized_box_for_whitespace, prefer_typing_uninitialized_variables, curly_braces_in_flow_control_structures, avoid_print

import 'dart:ui';
import 'smartcontract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'LoginPage.dart';

late String barcode;

class ShipperPage extends StatefulWidget {
  late final String uname;

  ShipperPage({required this.uname});

  @override
  _ShipperPageState createState() => _ShipperPageState();
}

class _ShipperPageState extends State<ShipperPage> {
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
                        "shipper",
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
                          "\nBlockchain provides all parties within a respective supply chain with access to the same information, potentially reducing communication or transfer data errors.",
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
                            child: Lottie.asset('assets/blockchain.json'),
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
                          height: 20,
                        ),
                        scanQR('Scan QR'),
                        SizedBox(
                          height: 20,
                        ),
                        ScanShippment('Ship the Item')
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

  scanQR(this.txt);

  Future _scan() async {
    await Permission.camera.request();
    barcode = (await scanner.scan())!;
  }

  String scannedCondition() {
    if (barcode == null)
      return "Couldn't Scan Item";
    else
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
      padding: EdgeInsets.all(18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Center(
          child: Text(txt,
              style: GoogleFonts.robotoSlab(
                  fontSize: 18, fontWeight: FontWeight.bold))),
    );
  }
}

class ScanShippment extends StatelessWidget {
  final String txt;
  List<String> allData = [];

  ScanShippment(this.txt);

  late int pd;
  late String status;
  SmartContract ethHelper = SmartContract();
  // ignore: non_constant_identifier_names
  Future INIT() async {
    int pd = int.parse(barcode);
    await ethHelper.addState(pd);
  }

  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    var progress = ProgressHUD.of(context);
    // ignore: deprecated_member_use
    return RaisedButton(
        onPressed: () async => {
              progress?.show(),
              progress!.showWithText('Shipping...'),
              Future.delayed(Duration(seconds: 3), () {
                progress.dismiss();
              }),
              await INIT(),
              Fluttertoast.showToast(
                  msg: "Successfully Shipped !",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.green,
                  fontSize: 16.0)
            },
        elevation: 5,
        padding: EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(txt,
                style: GoogleFonts.robotoSlab(
                    fontSize: 18, fontWeight: FontWeight.bold))));
  }
}
