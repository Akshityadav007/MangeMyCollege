import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String mynumber;

  static Future<String> getPhoneNumberSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("phoneNumber");
  }

  setNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mynumber = prefs.getString("phoneNumber");
  }
}
