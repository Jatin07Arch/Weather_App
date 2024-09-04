import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:weather_app/controller/getdata.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String temp = "";
  String hum = "";
  String air_speed = "";
  String des = "";
  String main = "";
  String icon = "";
  String city = "ahmedabad"; // Initialize with a default city

  void data_from_instance(String city) async {
    bool isValidCity = await validateCity(city);

    if (!isValidCity) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid City Name'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('The city name you entered is invalid or not found.'),
                  Text('Please enter a valid city name.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/");
                },
              ),
            ],
          );
        },
      );
      return;
    }

    GetData instance = GetData(location: city);
    await instance.getData();
    setState(() {
      temp = instance.temp;
      hum = instance.humidity;
      air_speed = instance.air_speed;
      des = instance.description;
      main = instance.main;
      icon = instance.icon;
    });

    // Navigate to home screen with data
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      "temp_value": temp,
      "hum_value": hum,
      "air_speed_value": air_speed,
      "des_value": des,
      "main_value": main,
      "icon_value": icon,
      "city_value": city
    });
  }

  Future<bool> validateCity(String city) async {
    try {
      Uri url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=5528c10e91daa51e62ab0c3ed9f4c86a");
      Response response = await get(url);

      if (response.statusCode == 200) {
        // City exists in the API's data
        return true;
      } else {
        // City not found or other error
        return false;
      }
    } catch (e) {
      // Exception occurred (e.g., network error)
      print("Error validating city: $e");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('searchText')) {
        setState(() {
          city = args['searchText'];
        });
      }
      data_from_instance(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 180),
              Image.asset("assets/images/AppLogo.png", height: 240, width: 240),
              Text(
                "Weather App",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Made By Jatin",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              SizedBox(height: 30),
              SpinKitWave(
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue[300],
    );
  }
}
