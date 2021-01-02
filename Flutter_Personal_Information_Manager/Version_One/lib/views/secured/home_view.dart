import 'package:flutter/material.dart';
import '../login_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lesson 1"),
        ),
        body: Container(child: SingleChildScrollView(padding: EdgeInsets.all(10.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, 
        children: <Widget>[Text("Widgets used", style: Theme.of(context).textTheme.headline4,),
              ListTile(title: Text("Container")),
              ListTile(title: Text("BoxDecoration")),
              ListTile(title: Text("SingleChildScrollView")),
              ListTile(title: Text("Column")),
              ListTile(title: Text("TextField")),
              ListTile(title: Text("InputDecoration")),
              ListTile(title: Text("AppBar")),
              ListTile(title: Text("Image")),
              ListTile(title: Text("ListTile")),
              MaterialButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (BuildContext context)=>LoginView()
                  ));
                },
                child: Text("Log Out"),
              )
              ]))));
  }
}
