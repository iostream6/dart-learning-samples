/*
 * 2021.01.19  - Created
 * 
 */

import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/sqldb_service.dart' as dao;
import 'package:provider/provider.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: _paddingForView(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<dao.EntityChangeManager<Contact>>(
                builder: (_, ccm, __) => ListView.builder(scrollDirection: Axis.vertical, shrinkWrap: true, itemBuilder: _listItem, itemCount: ccm.entities.length)),
          ],
        ),
      ),
    ); //can also use MultiProvider here!
  }

  Widget _listItem(BuildContext context, int index) {
    final Contact contact = Provider.of<dao.EntityChangeManager<Contact>>(context, listen: false).entities[index];
    return ChangeNotifierProvider.value(
      value: contact,
      child: Card(
        //color: Colors.blue[200],
        elevation: 2.0,
        child: Consumer<Contact>(builder: (_, c, __) {
          return ListTile(
            leading: FlutterLogo(size: 36.0),
            title: Text('${c.getFirstname()} ${c.getLastname()}'),
            subtitle: Text('${c.getPreferredNumber()}'),
          );
        }),
      ),
    );
  }

  EdgeInsets _paddingForView(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding;
    double topBottom = 8;
    if (width > 500) {
      padding = (width) * 0.05; // 5% padding of width on both side
    } else {
      padding = 8;
    }
    return EdgeInsets.only(left: padding, right: padding, top: topBottom, bottom: topBottom);
  }
}
