import 'package:flutter/material.dart';
import 'package:weather_app/view/home.dart';
import 'package:weather_app/view/loading.dart';
import 'package:weather_app/view/location.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      "/": (context) => Loading(),
      "/home": (context) => Home(),
      "/loading": (context) => Loading(),
    },
  ));
}
