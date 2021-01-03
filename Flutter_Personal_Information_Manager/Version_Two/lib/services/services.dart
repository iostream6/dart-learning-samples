/*
 * 2021.01.02  - Created
 * 2021.01.03  - Added async initialization method and made all other methods synchronous
 */

import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

const String HAS_ACCOUNT_KEY = 'HAS_ACCOUNT';
const String FULLNAME_KEY = 'fullname';
const String PASSWORD_KEY = 'password';
const String EMAIL_KEY = 'email';
SharedPreferences _sharedPrefs;

Future<bool> init() async {
  _sharedPrefs = await SharedPreferences.getInstance();
  return true;
}

bool hasAccount() {
  return _sharedPrefs == null ? false : _sharedPrefs.getBool(HAS_ACCOUNT_KEY) ?? false;
}

bool createAccount(String fullname, String email, String password) {
  if (_sharedPrefs == null) {
    return false;
  }
  _sharedPrefs.setString(FULLNAME_KEY, fullname);
  _sharedPrefs.setString(EMAIL_KEY, email);
  _sharedPrefs.setString(PASSWORD_KEY, password); //plain text, TODO hash?
  _sharedPrefs.setBool(HAS_ACCOUNT_KEY, true);
  return true;
}

bool authenticate({@required String currentPassword, String newPassword}) {
  if (_sharedPrefs == null) {
    return false;
  }
  final bool hasAccount = _sharedPrefs.getBool(HAS_ACCOUNT_KEY) ?? false;
  if (!hasAccount) {
    return false;
  }
  final bool authenticated = currentPassword == _sharedPrefs.getString(PASSWORD_KEY);
  if (authenticated && newPassword != null) {
    //change the password if required
    _sharedPrefs.setString(PASSWORD_KEY, newPassword); //plain text, TODO hash?
  }
  return authenticated;
}
