/*
 * 2021.01.02  - Created
 * 2021.01.08  - Added database init and provider state management for Notes
 */

import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'services/services.dart' as services;
import 'services/sqldb_service.dart' as dao;
import 'package:provider/provider.dart';

// void main() => runApp(FlutterPIMApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await services.init();
  await dao.getDatabase();

  // Note n =
  //     Note(null, 'Title', 'Body text', DateTime.now(), DateTime.now(), Colors.blue, false);
  // dao.insert(n, dao.NOTES_TABLE_NAME);
  // n =
  //     Note(null, 'Title2', 'Body text2', DateTime.now(), DateTime.now(), Colors.blue, false);
  // dao.insert(n, dao.NOTES_TABLE_NAME);
  // List<Map<String, dynamic>> res = await dao.select(dao.NOTES_TABLE_NAME);
  // res.forEach((t) async {
  //   print('Map Result \t ${t.toString()}');
  //   Note resNote = Note.fromBLOB(t);
  //   print('OBJ Result:: \t ${resNote.asString()}');
  //   await dao.delete(resNote, dao.NOTES_TABLE_NAME);
  // });

  dao.NotesChangeManager ncm = dao.NotesChangeManager();
  ncm.init();
  runApp(ChangeNotifierProvider(create: (_) => ncm, child: FlutterPIMApp()));
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
