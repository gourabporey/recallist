import 'package:hive_flutter/hive_flutter.dart';
import 'package:recallist/core/models/item.dart';

class HiveDataSource {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ItemAdapter());
    await Hive.openBox<int>('items_keys'); // Store auto-increment counter
    await Hive.openBox<Item>('items');
  }

  Box<Item> get itemsBox => Hive.box<Item>('items');
  Box<int> get keysBox => Hive.box<int>('items_keys');

  /// Get the next auto-increment ID
  int getNextId() {
    final currentId = keysBox.get('last_id', defaultValue: 0) ?? 0;
    final nextId = currentId + 1;
    keysBox.put('last_id', nextId);
    return nextId;
  }
}
