import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreference {
  static SharedPreferences? _preferences;
  static const _keyUserName = 'username';
  static const _loginStatus = "loginstatus";

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserName(String username) async {
    await _preferences!.setString(_keyUserName, username);
  }

  static Future setRememberMeStatus(bool status) async {
    await _preferences!.setBool(_loginStatus, status);
  }

  static String getUserName() => _preferences!.getString(_keyUserName) ?? '';
  static bool getRememberMeStatus() =>
      _preferences!.getBool(_loginStatus) ?? false;
}
