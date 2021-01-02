import 'package:flutter/material.dart';
import 'secured/home_view.dart';
import '../services/services.dart';

final String logo = "assets/images/logo.png";
bool accountIsSetup = false;

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkAccount();
    return Scaffold(
      //appBar: null,
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            Image.asset(
              logo,
              height: 100,
            ),
            SizedBox(
              height: 60.0,
            ),
            //
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Username", prefixIcon: Icon(Icons.face), fillColor: Colors.white54, filled: true),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Password", prefixIcon: Icon(Icons.vpn_key), fillColor: Colors.white54, filled: true),
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 10.0)),
                //color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeView()));
                },
                child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 20.0)),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Visibility(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SignupView()));
                  },
                  child: Text("Not set up yet? Create Account", style: TextStyle(color: Colors.blue)),
                ),
                visible: !accountIsSetup,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  _checkAccount() async {
    accountIsSetup = await hasAccount();
  }
}

class SignupView extends StatelessWidget {
  final _fullnameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _password2TextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          //backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          elevation: 0,
          title: Text('Signup Page'),
        ),
        body: Container(
            height: double.infinity,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
                  TextField(
                    controller: _fullnameTextController,
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Full Name", prefixIcon: Icon(Icons.face), fillColor: Colors.white54, filled: true),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: _emailTextController,
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Email address", prefixIcon: Icon(Icons.alternate_email), fillColor: Colors.white54, filled: true),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    obscureText: true,
                    controller: _passwordTextController,
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Password", prefixIcon: Icon(Icons.vpn_key), fillColor: Colors.white54, filled: true),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    obscureText: true,
                    controller: _password2TextController,
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Confirm Password", prefixIcon: Icon(Icons.vpn_key), fillColor: Colors.white54, filled: true),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 10.0)),
                      //color: Theme.of(context).primaryColor,
                      onPressed: () {
                        // String errorMessage = null;
                        // if (_passwordTextController.text != _password2TextController.text) {
                        //   errorMessage = 'Passwords do not match!';
                        // }
                        // if (_fullnameTextController.text == null || _fullnameTextController.text.length == 0) {
                        //   errorMessage = 'Fullname must be provided!';
                        // }

                        // if (_passwordTextController.text == _password2TextController.text) {
                        //   createAccount(_fullnameTextController.text, _emailTextController.text, _passwordTextController.text).then((success) {
                        //     if (success) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeView()));
                        //     }
                        //   });
                        // } else {
                        //   print('Passwords do not match!');
                        // }

                        //
                      },
                      child: Text("Signup", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Already a member? Login", style: TextStyle(color: Colors.blue)),
                    ),
                  )
                ]))));
  }
}
