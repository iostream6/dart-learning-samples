/*
 * 2021.01.02  - Created
 * 2021.01.08  - Added database init and provider state management for Notes
 */

import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'services/services.dart' as services;
import 'services/sqldb_service.dart' as dao;
import 'package:provider/provider.dart';
import 'models/models.dart';

// void main() => runApp(FlutterPIMApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await services.init();
  await dao.getDatabase();

  // Note n = Note(null, 'Title', 'Body text', DateTime.now(), DateTime.now(), Colors.blue, false);
  // dao.insert(n, dao.NOTES_TABLE_NAME);
  // n =  Note(null, 'Title2', 'Body text2', DateTime.now(), DateTime.now(), Colors.blue, false);
  // dao.insert(n, dao.NOTES_TABLE_NAME);
  // List<Map<String, dynamic>> res = await dao.select(dao.NOTES_TABLE_NAME);
  // res.forEach((t) async {
  //   print('Map Result \t ${t.toString()}');
  //   //Note resNote = Note.fromBLOB(t);
  //   //print('OBJ Result:: \t ${resNote.asString()}');
  //   //await dao.delete(resNote, dao.NOTES_TABLE_NAME);
  // });

  dao.EntityChangeManager<Note> ncm = dao.EntityChangeManager<Note>(dao.NOTES_TABLE_NAME, 'edited desc', 'archived = ?', [0], (e) => Note.fromBLOB(e));
  ncm.init();

  dao.EntityChangeManager<Contact> ccm = dao.EntityChangeManager<Contact>(dao.CONTACTS_TABLE_NAME, 'firstname desc', null, null, (e) => Contact.fromMap(e));
  ccm.init();

  // Contact c = Contact(0, 'Osho', 'Ilamah', 'oilamah@wonders.com', [ContactNumber('052222246', 0, 0), ContactNumber('0846667121', 1, 1)]);
  // ccm.insertEntity(c);
  // c = Contact(0, 'Florence', 'Ilamah', 'feilamah@xxxs.com', [ContactNumber('052222246', 0, 0), ContactNumber('0803888887', 1, 1)]);
  // ccm.insertEntity(c);

  List<Map<String, dynamic>> res = await dao.select(dao.CONTACTS_TABLE_NAME);
  res.forEach((element) {
    Contact c = Contact.fromMap(element);
    print('trying');
  });


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
      debugShowCheckedModeBanner: false,
    );
  }
}
