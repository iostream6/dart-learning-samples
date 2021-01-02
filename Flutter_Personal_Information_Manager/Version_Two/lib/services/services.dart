import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

final _prefs = SharedPreferences.getInstance();

Future<bool> hasAccount() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.get('hasAccount') != null;
}

Future<bool> createAccount(String fullname, String email, String password) async {
  final SharedPreferences prefs = await _prefs;
  prefs.setString('fullname', fullname);
  prefs.setString('email', email);
  prefs.setString('password', password); //plain text, TODO hash?
  prefs.setBool('hasAccount', true);

  return true;
}

Future<bool> authenticate({@required String currentPassword, String newPassword}) async {
  final SharedPreferences prefs = await _prefs;
  final bool hasAccount = prefs.get('hasAccount') != null;

  if (!hasAccount) {
    return false;
  }

  final bool authenticated = currentPassword == prefs.getString('password');
  if (authenticated && newPassword != null) {
    //change the password if required
    prefs.setString('password', newPassword); //plain text, TODO hash?
  }
  return authenticated;
}
