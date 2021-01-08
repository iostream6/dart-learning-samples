/*
 * 2021.01.08  - Created
 * 
 */
import 'package:flutter/material.dart';
import 'dart:convert';

abstract class Transformable {
  Map<String, dynamic> asMap();

  String asString();

  int id;

  Transformable._(this.id);
}

class NoteChangeManager with ChangeNotifier {
  void sendChangeNotification() {
    notifyListeners();
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
