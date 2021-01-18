/*
 * 2021.01.08  - Created
 * 2021.01.09  - Added Note.fromOther() named constructor
 * 2021.01.18  - Added Contact model class
 */
import 'package:flutter/material.dart';
import 'dart:convert';

abstract class Transformable {
  Map<String, dynamic> asMap();

  String asString();

  int id;

  Transformable._(this.id);
}

class Contact extends Transformable {
  String firstname, lastname, email;
  List<ContactNumber> numbers;

  Contact(id, this.firstname, this.lastname, this.email, this.numbers) : super._(id);

  static Contact fromMap(Map<String, dynamic> dbMap) {
    Contact _nc = Contact(dbMap['id'], dbMap['firstname'], dbMap['lastname'], dbMap['email'], null);
    _nc.numbers = [];
    List _numbers = dbMap['numbers']; //TODO _TypeError (type 'String' is not a subtype of type 'List<dynamic>')

    _numbers.forEach((contactNumberMap) {
      ContactNumber _cnc = ContactNumber.fromMap(contactNumberMap);
      _nc.numbers.add(_cnc);
    });
    return _nc;
  }

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'numbers': numbers.toString(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String asString() {
    return {'id': id, 'firstname': firstname, 'lastname': lastname, 'email': email, 'numbers': numbers}.toString();
  }
}

class ContactNumber {
  String number;
  int priority;
  int cid;

  ContactNumber(this.number, this.priority, this.cid);

  ContactNumber.fromMap(Map<String, dynamic> dbMap) : this(dbMap['number'], dbMap['priority'], dbMap['cid']);

  Map<String, dynamic> asMap() {
    var map = {'number': number, 'priority': priority};
    if (cid != null) {
      map['cid'] = cid;
    }
    return map;
  }

  @override
  String toString() {
    return asMap().toString();
  }
}

class Note extends Transformable with ChangeNotifier {
  String title;
  String body;
  DateTime created;
  DateTime edited;

  Color color;
  bool archived;

  /// Constructs a [Note] object.
  Note(id, this.title, this.body, this.created, this.edited, this.color, [this.archived]) : super._(id);

  /// Named constructor. Constructs a Note object from database record map.
  Note.fromBLOB(Map<String, dynamic> dbMap)
      : this(dbMap['id'], utf8.decode(dbMap['title']), utf8.decode(dbMap['body']), DateTime.fromMillisecondsSinceEpoch(1000 * dbMap['created']),
            DateTime.fromMillisecondsSinceEpoch(1000 * dbMap['edited']), Color(dbMap['color']), dbMap['archived'] == 1);

  Note.fromOther(Note other) : super._(other.id) {
    this.title = other.title;
    this.body = other.body;
    this.created = DateTime.fromMillisecondsSinceEpoch(other.created.millisecondsSinceEpoch);
    this.edited = DateTime.fromMillisecondsSinceEpoch(other.edited.millisecondsSinceEpoch);
    this.color = Color(other.color.value);
    this.archived = (other.archived == true);
  }

  /// Provides a [Map] represention of the note.
  @override
  Map<String, dynamic> asMap() {
    var map = {'title': utf8.encode(title), 'body': utf8.encode(body), 'created': _epochFromDate(created), 'edited': _epochFromDate(edited), 'color': color.value, 'archived': archived ? 1 : 0};
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  /// Sets the archived status of this Note to the value specified by the [archive] argument.
  void setArchived(bool archive) {
    archived = archive;
  }

  // Converts a DateTime object into integer representing seconds since midnight 1st Jan, 1970 UTC
  int _epochFromDate(DateTime dt) {
    return dt.millisecondsSinceEpoch ~/ 1000;
  }

  /// Returns a String representation of this Note.
  @override
  String asString() {
    return {'id': id, 'title': title, 'body': body, 'created': _epochFromDate(created), 'edited': _epochFromDate(edited), 'color': color.toString(), 'archived': archived}.toString();
  }

  void sendChangeNotification() {
    notifyListeners();
  }
}
