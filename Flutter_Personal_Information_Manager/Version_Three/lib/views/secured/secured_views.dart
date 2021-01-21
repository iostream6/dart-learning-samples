/*
 * 2021.01.03  - Created
 * 2021.01.09  - Added add() action support to allow adding objects(Notes)
 * 2021.01.21  - Added add() action support to allow adding Contacts
 */

import 'package:flutter/material.dart';
import 'notes_list_view.dart';
import 'note_view.dart';
import 'contacts_list_view.dart';
import 'contact_view.dart';
import '../../models/models.dart';
//import '../login_view.dart';

class SecuredPageView extends StatefulWidget {
  @override
  _SecuredPageViewState createState() => _SecuredPageViewState();
}

class _SecuredPageViewState extends State<SecuredPageView> {
  int _selectedViewIndex = 0;

  final duration = Duration(milliseconds: 300);

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutterPIM"),
        actions: _appBarActions(context),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: PageView(
          controller: _controller,
          onPageChanged: (int index) => setState(() => _selectedViewIndex = index),
          pageSnapping: true,
          scrollDirection: Axis.horizontal,
          children: <Widget>[NotesGridPage(ViewType.Staggered), ContactsPage(), _getXXXListWidget()],
        ),
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _getXXXListWidget() {
    return Container(
        color: Colors.blueAccent,
        child: Center(
            child: Text(
          'This is Widget 3',
          style: TextStyle(fontSize: 25, color: Colors.black),
        )));
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Notes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          label: 'Contacts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.today),
          label: 'Tasks',
        )
      ],
      currentIndex: _selectedViewIndex,
      onTap: (int index) {
        setState(() {
          _selectedViewIndex = index;
          _controller.animateToPage(index, duration: duration, curve: Curves.ease);
        });
      },
    );
  }

  List<Widget> _appBarActions(BuildContext context) {
    List<Widget> actions = [];
    actions.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        child: GestureDetector(
          onTap: () => _addObjectHandler(context),
          child: Icon(
            Icons.add,
            //color: ViewProperties.FONT_COLOR,
          ),
        ),
      ),
    ));
    return actions;
  }

  void _addObjectHandler(BuildContext ctx) {
    switch (_selectedViewIndex) {
      case 0:
        Note newNote = Note(null, 'Title', 'Body', DateTime.now(), DateTime.now(), Colors.blue, false);
        Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => NoteView(newNote)));
        break;
      case 1:
        Contact newContact = Contact(null, null, null, []);
        Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => ContactView(newContact)));
        break;
      case 2:
        break;
    }
  }
}
