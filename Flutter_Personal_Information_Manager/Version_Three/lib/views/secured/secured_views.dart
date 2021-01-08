/*
 * 2021.01.03  - Created
 * 
 */

import 'package:flutter/material.dart';
import 'notes_list_view.dart';
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
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: PageView(
          controller: _controller,
          onPageChanged: (int index) => setState(() => _selectedViewIndex = index),
          pageSnapping: true,
          scrollDirection: Axis.horizontal,
          children: <Widget>[NotesGridPage(ViewType.Staggered), _getContactsListWidget(), _getXXXListWidget()],
        ),
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _getContactsListWidget() {
    return Container(
        color: Colors.pink,
        child: Center(
            child: Text(
          'This is Widget 2',
          style: TextStyle(fontSize: 25, color: Colors.black),
        )));
  }

  // Widget _getNotesListWidget() {
  //   return Container(
  //       color: Colors.grey,
  //       child: Center(
  //           child: Text(
  //         'This is Widget 2',
  //         style: TextStyle(fontSize: 25, color: Colors.white),
  //       )));
  // }

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
}
