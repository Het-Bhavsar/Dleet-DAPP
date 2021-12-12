// ignore_for_file: import_of_legacy_library_into_null_safe, unused_local_variable, deprecated_member_use, duplicate_ignore, must_be_immutable, avoid_print, prefer_const_constructors, file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unnecessary_new, sized_box_for_whitespace, prefer_typing_uninitialized_variables, avoid_single_cascade_in_expression_statements

import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'LoginPage.dart';
import 'smartcontract.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

late String productDesc;
late String productName;
String barcode = '-1';
late String name;

class ManufacturerPage extends StatelessWidget {
  late final String uname;
  ManufacturerPage({required this.uname});
  @override
  Widget build(BuildContext context) {
    name = uname;
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
                          "\nBuilt on  Polygon blockchain",
                          style: GoogleFonts.robotoSlab(
                              letterSpacing: 1,
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2)),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: TextField(
                            onChanged: (value) {
                              productName = value;
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.teal,
                                  ),
                                ),
                                hintStyle: GoogleFonts.robotoSlab(
                                  fontSize: 18,
                                ),
                                hintText: "Enter Product Name"),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: TextField(
                            onChanged: (value) {
                              productDesc = value;
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.teal,
                                  ),
                                ),
                                hintStyle: GoogleFonts.robotoSlab(
                                  fontSize: 18,
                                ),
                                hintText: "Product Details"),
                          ),
                        ),
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
                        AddProduct("Add the Product"),
                        SizedBox(
                          height: 20,
                        ),
                        FetchQr('Fetch QR Code')
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

class AddProduct extends StatefulWidget {
  final txt;

  AddProduct(this.txt);
  SmartContract ethHelper = SmartContract();
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    SmartContract ethHelper = SmartContract();
    final Size size = MediaQuery.of(context).size;
    // ignore: deprecated_member_use
    var progress = ProgressHUD.of(context);
    return RaisedButton(
      onPressed: () async => {
        progress?.show(),
        progress!.showWithText('Adding...'),
        Future.delayed(Duration(seconds: 4), () {
          progress.dismiss();
        }),
        await ethHelper.newItem(productName, productDesc, name),
        Fluttertoast.showToast(
            msg: "Item added",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.green,
            fontSize: 16.0)
      },
      elevation: 5,
      padding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Center(
          child: Text(widget.txt,
              style: GoogleFonts.robotoSlab(
                  fontSize: 18, fontWeight: FontWeight.bold))),
    );
  }
}

class FetchQr extends StatefulWidget {
  final String txt;

  FetchQr(this.txt);

  @override
  _FetchQrState createState() => _FetchQrState();
}

class _FetchQrState extends State<FetchQr> {
  late String str;
  Future<String> getBarcode() async {
    String s = await ethHelper.getProductID();
    print(s);
    return s;
  }

  SmartContract ethHelper = SmartContract();
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    // ignore: deprecated_member_use
    var progress = ProgressHUD.of(context);
    return RaisedButton(
      onPressed: () async => {
        progress?.show(),
        progress!.showWithText('Loading...'),
        Future.delayed(Duration(seconds: 12), () async {
          progress.dismiss();
        }),
        for (int i = 0; i < 50; i++) barcode = await getBarcode(),
        setState(() {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            borderSide: BorderSide(color: Colors.white, width: 2),
            width: 280,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
            headerAnimationLoop: true,
            body: Column(
              children: [
                Text(
                  "Item Added Successfully!",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                QrImage(
                  data: barcode,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ],
            ),
            animType: AnimType.BOTTOMSLIDE,
            title: 'INFO',
            desc: 'Item Added Successfully!',
            showCloseIcon: true,
          )..show();
        })
      },
      elevation: 5,
      padding: EdgeInsets.all(18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Center(
          child: Text(widget.txt,
              style: GoogleFonts.robotoSlab(
                  fontSize: 18, fontWeight: FontWeight.bold))),
    );
  }
}
