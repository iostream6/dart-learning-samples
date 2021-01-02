import 'package:flutter/material.dart';
import '../login_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            padding: EdgeInsets.all(10.0),
            children: <Widget>[
              TextButton(
                //style: TextButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Text Button"),
                onPressed: () {
                  //print("flat button pressed");
                },
              ),
              ElevatedButton(
                child: Text("Elevated Button"),
                //color: Colors.green,
                onPressed: () {
                  //print("Elevated button pressed");
                },
              ),
              OutlinedButton(
                child: Text("Outlined Button"),
                //color: Colors.deepOrange,
                onPressed: () {
                  print("material button presse");
                },
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.add_a_photo),
                onPressed: () {
                  //print("Elevated button with icon pressed");
                },
                label: Text('Elevated Button Icon'),
              ),
              TextButton.icon(
                label: Text("Text button icon"),
                icon: Icon(Icons.play_circle_filled),
                onPressed: () {
                  //print("Flat button with icon pressed");
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.pink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                child: Text("Rounded Elevated Button"),
                onPressed: () {
                  //print("Rounded raised button pressed");
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue, shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                child: Text("Beveled Elevated Button"),
                onPressed: () {
                  //print("Beveled raised button pressed");
                },
              ),
              IconButton(
                color: Colors.deepPurple,
                iconSize: 40.0,
                icon: Icon(Icons.plus_one),
                onPressed: () {
                  print("Icon button pressed");
                },
              ),
              FloatingActionButton(
                child: Icon(Icons.dashboard),
                backgroundColor: Colors.green,
                onPressed: () {
                  //print("floating action button 2 pressed");
                  Navigator.pushReplacement(context, MaterialPageRoute(
                       builder: (BuildContext context)=>LoginView()
                     ));
                },
              )
            ],
          ),
          // Column(crossAxisAlignment: CrossAxisAlignment.start,
          // children: <Widget>[Text("Widgets used", style: Theme.of(context).textTheme.headline4,),
          //       ListTile(title: Text("Container")),
          //       ListTile(title: Text("BoxDecoration")),
          //       ListTile(title: Text("SingleChildScrollView")),
          //       ListTile(title: Text("Column")),
          //       ListTile(title: Text("TextField")),
          //       ListTile(title: Text("InputDecoration")),
          //       ListTile(title: Text("AppBar")),
          //       ListTile(title: Text("Image")),
          //       ListTile(title: Text("ListTile")),
          //       MaterialButton(
          //         onPressed: (){
          //           Navigator.pushReplacement(context, MaterialPageRoute(
          //             builder: (BuildContext context)=>LoginView()
          //           ));
          //         },
          //         child: Text("Log Out"),
          //       )
          //       ])
        ));
  }
}
