import 'package:shared_preferences/shared_preferences.dart';

void SaveTokenToSessionManager(
  String token,
) async {
  final sharedpref = await SharedPreferences.getInstance();
  sharedpref.setBool('isLogin', true);
  sharedpref.setString('isToken', token);
}

void logout() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('isLogin');
  await prefs.remove('isToken');
}

Future<bool?> getIsLogin() async {
  // Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? isLogin = prefs.getBool('isLogin');
  return isLogin;
}


Future<String?> getIsToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? isToken = prefs.getString('isToken');
  return isToken;
}
