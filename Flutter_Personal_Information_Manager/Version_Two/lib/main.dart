/*
 * 2021.01.02  - Created
 * 
 */

import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'services/services.dart' as services;

// void main() => runApp(FlutterPIMApp());

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await services.init();
  runApp(FlutterPIMApp());
  //services.init().then((value) => runApp(FlutterPIMApp()));
}

class FlutterPIMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterPIM',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginView(), //main container, should be a scaffold
    );
  }
}
