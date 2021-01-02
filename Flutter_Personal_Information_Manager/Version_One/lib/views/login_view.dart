import 'package:flutter/material.dart';
import 'secured/home_view.dart';

final String logo = "assets/images/logo.png";

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: null,
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Image.asset(
              logo,
              height: 100,
            ),
            SizedBox(
              height: 30.0,
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
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (BuildContext context)=>HomeView()
                  ));
                },
                child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 20.0)),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SignupView()));
              },
              child: Text("Not a member yet? Create Account", style: TextStyle(color: Colors.blue)),
            )
          ]),
        ),
      ),
    );
  }
}

class SignupView extends StatelessWidget {
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
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Full Name", prefixIcon: Icon(Icons.face), fillColor: Colors.white54, filled: true),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Email address", prefixIcon: Icon(Icons.alternate_email), fillColor: Colors.white54, filled: true),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Password", prefixIcon: Icon(Icons.vpn_key), fillColor: Colors.white54, filled: true),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Confirm Password", prefixIcon: Icon(Icons.vpn_key), fillColor: Colors.white54, filled: true),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeView()));
                      },
                      child: Text("Signup", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Already a member? Login", style: TextStyle(color: Colors.blue)),
                  )
                ]))));
  }
}
