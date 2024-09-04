import 'dart:convert';
import 'package:http/http.dart';

class GetData {
  String location = "";
  String temp = "";
  String humidity = "";
  String air_speed = "";
  String description = "";
  String main = "";
  String icon = "";

  GetData({required this.location}) {
    location = this.location;
  }

  Future<void> getData() async {
    try {
      // Get Data
      Uri url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=5528c10e91daa51e62ab0c3ed9f4c86a");
      Response response = await get(url);

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);

        // Getting temp, Humidity
        Map temp_data = data['main'];
        String getHumidity = temp_data['humidity'].toString();
        double getTemp = temp_data['temp'] - 273.15;

        // Getting air speed
        Map wind = data['wind'];
        double getAirSpeed = wind['speed'] / 0.27777777777778;

        // Getting Description
        List weather_data = data['weather'];
        Map weather_main_data = weather_data[0];
        String getMainDes = weather_main_data['main'];
        String getDesc = weather_main_data['description'];

        temp = getTemp.toString();
        humidity = getHumidity.toString();
        air_speed = getAirSpeed.toString();
        description = getDesc;
        main = getMainDes;
        icon = weather_main_data["icon"].toString();
      } else {
        print("Failed to load weather data");
      }
    } catch (e) {
      print("Error: $e");
      temp = "Error";
      humidity = "Error";
      air_speed = "Error";
      description = "Error";
      main = "Error";
      icon = "09d";
    }
  }
}
