import 'package:shared_preferences/shared_preferences.dart';

void SaveTokenToSessionManager(
  String token,
) async {
  final sharedpref = await SharedPreferences.getInstance();
  sharedpref.setBool('isLogin', true);
  sharedpref.setString('isToken', token);
}

Future<String?> getIsToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? isToken = prefs.getString('isToken');
  return isToken;
}
