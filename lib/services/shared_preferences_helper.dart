import 'package:shared_preferences/shared_preferences.dart';
class SharedPreferencesHelper {
  static Future<void> storeuserId(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
  }
  static Future<String?> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('uid');
    return token;
  }
    static Future<void> storeUserRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }
  static Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('role');
    return token;
  }
}