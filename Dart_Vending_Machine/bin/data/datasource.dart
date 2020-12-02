import '../models/models.dart';
import 'package:uuid/uuid.dart';

abstract class DataSource<T> {
  bool add(T item);
  T read(var id);

  Iterable<T> readAll();

  T update(T item);

  T delete(var id);
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
  Item delete(id) {
    return map.remove(id);
  }

  @override
  Item read(id) {
    return map[id];
  }

  @override
  Iterable<Item> readAll() {
    return map.values;
  }

  @override
  Item update(Item item) {
    map[item.id] = item;
    return item;
  }
}
