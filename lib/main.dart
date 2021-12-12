// @dart=2.9
// ignore_for_file: unused_import, use_key_in_widget_constructors, unused_element

import 'dart:io';

import 'LoginPage.dart';
import 'ManufacturerPage.dart';
import 'themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fi',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: LoginPage(),
    );
  }
}
