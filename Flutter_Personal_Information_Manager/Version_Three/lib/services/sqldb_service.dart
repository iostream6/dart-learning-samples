/*
 * 2021.01.08  - Created
 * 2021.01.09  - Added record update() support
 * 2021.01.18  - Added generic EntityChangeManager class to replace specific entity managers 
 */
import '../models/models.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

const _DATABASE_NAME = 'fx_pim.db';

const NOTES_TABLE_NAME = 'notes';
const _NOTES_TABLE_SCHEMA = {'id': 'INTEGER PRIMARY KEY AUTOINCREMENT', 'title': 'BLOB', 'body': 'BLOB', 'created': 'INTEGER', 'edited': 'INTEGER', 'color': 'INTEGER', 'archived': 'INTEGER'};

const CONTACTS_TABLE_NAME = 'contacts';
const _CONTACTS_TABLE_SCHEMA = {'id': 'INTEGER PRIMARY KEY AUTOINCREMENT', 'firstname': 'STRING', 'lastname': 'STRING', 'email': 'STRING', 'numbers': 'String'};

Database _database;

String _buildCreateTableQuery(String tableName, Map<String, String> fieldsMap) {
  String query = 'CREATE TABLE IF NOT EXISTS $tableName (';
  fieldsMap.forEach((columnName, columnType) {
    //print('$column : $field');
    query += '$columnName $columnType,';
  });
  query = query.substring(0, query.length - 1);
  query += ' )';
  print('CREATE TABLE QUERY:: $query');
  return query;
}

Future<Database> _initDB() async {
  var path = await getDatabasesPath();
  var dbPath = join(path, _DATABASE_NAME);
  // ignore: argument_type_not_assignable
  Database dbConnection = await openDatabase(dbPath, version: 1, onCreate: (Database db, int version) async {
    print('executing create query from onCreate callback');
    await db.execute(_buildCreateTableQuery(NOTES_TABLE_NAME, _NOTES_TABLE_SCHEMA));
    await db.execute(_buildCreateTableQuery(CONTACTS_TABLE_NAME, _CONTACTS_TABLE_SCHEMA));
  });

  return dbConnection;
}

// Future<String> _getDBPath() async {
//   String path = await getDatabasesPath();
//   return path;
// }

Future<Database> getDatabase() async {
  if (_database != null) {
    return _database;
  }

  _database = await _initDB();
  return _database;
}

Future<int> insert(Transformable t, String tableName) async {
  t.id = await _database.insert(tableName, t.asMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  return t.id;
}

Future<int> update(Transformable t, String tableName) async {
  return await _database.update(tableName, t.asMap(), where: 'id = ?', whereArgs: [t.id]);
}

Future<List<Map<String, dynamic>>> select(String tableName, {String orderByString, String whereString, List<dynamic> whereArgs}) async {
  var data = await _database.query(tableName, orderBy: orderByString, where: whereString, whereArgs: whereArgs);
  return data;
}

Future<bool> delete(Transformable t, String tableName) async {
  if (t.id != null) {
    try {
      await _database.delete(tableName, where: "id = ?", whereArgs: [t.id]);
      return true;
    } catch (Error) {
      print("Error deleting ${t.id}: ${Error.toString()}");
    }
  }
  return false;
}

class EntityChangeManager<T extends Transformable> with ChangeNotifier {
  final String table;
  final String orderBy;
  final String whereString;
  final List<dynamic> whereArgs;
  List entities;

  final Function mapper;

  EntityChangeManager(this.table, this.orderBy, this.whereString, this.whereArgs, this.mapper);

  void init() async {
    select(table, orderByString: orderBy, whereString: whereString, whereArgs: whereArgs).then((List<Map<String, dynamic>> res) {
      //print('Getting ready');
      //xx =  res.map(mapper).toList();
      entities = res.map(mapper).toList();
      notifyListeners();
    });
  }

  void insertEntity(T entity) {
    insert(entity, table).then((int id) {
      if (id > 0) {
        entities.add(entity);
        notifyListeners();
      }
    });
  }

  void updateEntity(T entity) {
    update(entity, table).then((int count) {
      if (count > 0) {
        notifyListeners();
      }
    });
  }

  void deleteEntity(T entity) {
    delete(entity, table).then((bool success) {
      if (success) {
        entities.removeWhere((element) => element.id == entity.id);
        notifyListeners();
      }
    });
  }
}