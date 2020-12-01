import '../models/models.dart';
import 'package:uuid/uuid.dart';

abstract class DataSource<T> {
  bool add(T item);
  T read(var id);

  Iterable<T> readAll();

  T update(T item);

  bool delete(var id);
}

class MemoryMapItemDataSource implements DataSource<Item> {
  final Map<String, Item> map = {};

  @override
  bool add(Item item) {
    if (item.id == null) {
      var uuid = Uuid();
      item.id = uuid.v4();
      map[item.id] = item;
      return true;
    } else {
      return false;
    }
  }

  @override
  bool delete(id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Item read(id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Iterable<Item> readAll() {
    return map.values;
  }

  @override
  Item update(Item item) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
