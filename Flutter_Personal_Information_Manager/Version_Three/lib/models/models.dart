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

class Contact extends Transformable with ChangeNotifier {
  String _fullname, _email;
  List<ContactNumber> _numbers;

  Contact([id, this._fullname, this._email, this._numbers]) : super._(id);

  static Contact fromMap(Map<String, dynamic> dbMap) {
    Contact __nc = Contact(dbMap['id'], dbMap['fullname'], dbMap['email'], null);
    __nc._numbers = [];
    List contactNumbersMapList = jsonDecode(dbMap['numbers']);
    contactNumbersMapList.forEach((contactNumberMap) {
      ContactNumber contactNumber = ContactNumber.fromMap(contactNumberMap);
      __nc._numbers.add(contactNumber);
    });
    return __nc;
  }

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> map = {
      'fullname': _fullname,
      'email': _email,
      'numbers': jsonEncode(_numbers),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String asString() {
    return {'id': id, 'fullname': _fullname, 'email': _email, 'numbers': _numbers}.toString();
  }

  String get fullname => _fullname;

  set fullname(String fullname) {
    if (fullname != _fullname && fullname != null) {
      _fullname = fullname;
      notifyListeners();
    }
  }

  String get email => _email;

  set email(String email) {
    if (_email != email && email != null) {
      _email = email;
      notifyListeners();
    }
  }

  bool _numbersEquals(List<String> nums) {
    if (_numbers == null || nums.length != _numbers.length) {
      return false;
    }
    for (int i = 0; i < nums.length; i++) {
      if (nums[i] != _numbers[i]._number) {
        return false;
      }
    }
    return true;
  }

  set numbers(List<String> nums) {
    if (_numbersEquals(nums) == false) {
      if (_numbers.length > 0) {
        _numbers[0]._number = nums[0]; //only need to change the number!
      } else {
        _numbers.add(ContactNumber(nums[0], 0, 0, 0));
      }
      if (nums.length > 1) {
        if (_numbers.length > 1) {
          _numbers[1]._number = nums[1]; //only need to change the number!
        } else {
          _numbers.add(ContactNumber(nums[1], 1, 1, 1));
        }
      }
    }
  }

  int get numbersCount => _numbers.length;

  ContactNumber get firstNumber => _numbers.length > 0 ? _numbers[0] : null;

  ContactNumber get secondNumber => _numbers.length > 1 ? _numbers[1] : null;

  String get preferredNumber => _numbers.length > 0 ? _numbers.first._number : '';
}

class ContactNumber {
  String _number;
  int _type, _priority;
  int _cid;

  ContactNumber(this._number, this._type, this._priority, this._cid);

  ContactNumber.fromMap(Map<String, dynamic> dbMap) : this(dbMap['number'], dbMap['type'], dbMap['priority'], dbMap['cid']);

  Map<String, dynamic> toJson() {
    var map = {'number': _number, 'type': _type, 'priority': _priority};
    if (_cid != null) {
      map['cid'] = _cid;
    }
    return map;
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
}
