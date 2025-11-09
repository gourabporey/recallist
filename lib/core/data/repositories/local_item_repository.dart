import 'package:recallist/core/data/datasources/hive_data_source.dart';
import 'package:recallist/core/data/repositories/item_repository.dart';
import 'package:recallist/core/models/item.dart';

class LocalItemRepository implements ItemRepository {
  final HiveDataSource dataSource;

  LocalItemRepository(this.dataSource);

  @override
  Future<List<Item>> getAllItems() async {
    return dataSource.itemsBox.values.toList();
  }

  @override
  Future<void> addItem(Item item) async {
    // If item doesn't have an ID, generate one
    final itemToSave = item.id == 0
        ? Item(
            id: dataSource.getNextId(),
            title: item.title,
            notes: item.notes,
            tags: item.tags,
            links: item.links,
            images: item.images,
            createdDate: item.createdDate,
            revisions: item.revisions,
            revisionPattern: item.revisionPattern,
          )
        : item;
    await dataSource.itemsBox.put(itemToSave.id, itemToSave);
  }

  @override
  Future<void> updateItem(Item item) async {
    await dataSource.itemsBox.put(item.id, item);
  }

  @override
  Future<void> deleteItem(int id) async {
    await dataSource.itemsBox.delete(id);
  }
}
