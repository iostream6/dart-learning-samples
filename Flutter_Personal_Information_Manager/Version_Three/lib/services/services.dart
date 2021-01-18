/*
 * 2021.01.02  - Created
 * 2021.01.03  - Added async initialization method and made all other methods synchronous.
 *               Removed hasAccount methods - not needed, replaced with getEmail
 */

import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

const String FULLNAME_KEY = 'fullname';
const String PASSWORD_KEY = 'password';
const String EMAIL_KEY = 'email';
SharedPreferences _sharedPrefs;

Future<bool> init() async {
  _sharedPrefs = await SharedPreferences.getInstance();
  return true;
}

String getEmail() {
  return _sharedPrefs?.getString(EMAIL_KEY);
}

bool createAccount(String fullname, String email, String password) {
  if (_sharedPrefs == null) {
    return false;
  }
  _sharedPrefs.setString(FULLNAME_KEY, fullname);
  _sharedPrefs.setString(EMAIL_KEY, email);
  _sharedPrefs.setString(PASSWORD_KEY, password); 
  return true;
}

bool authenticate({@required String email, @required String currentPassword, String newPassword}) {
  if (_sharedPrefs == null || _sharedPrefs.getString(EMAIL_KEY) == null) {
    return false;
  }
  final bool authenticated = /*currentPassword == _sharedPrefs.getString(PASSWORD_KEY) &&*/ email == _sharedPrefs.getString(EMAIL_KEY) ;
  if (authenticated && newPassword != null) {
    //change the password if required
    _sharedPrefs.setString(PASSWORD_KEY, newPassword); 
  }
  return authenticated;
}
