import 'package:get_it/get_it.dart';
import 'package:recallist/core/data/datasources/hive_data_source.dart';
import 'package:recallist/core/data/repositories/item_repository.dart';
import 'package:recallist/core/data/repositories/local_item_repository.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Initialize Hive before anything else
  await HiveDataSource.init();

  // Register HiveDataSource as a singleton
  sl.registerLazySingleton<HiveDataSource>(() => HiveDataSource());

  // Register repository implementation
  sl.registerLazySingleton<LocalItemRepository>(
    () => LocalItemRepository(sl<HiveDataSource>()),
  );

  // Register repository interface
  sl.registerLazySingleton<ItemRepository>(
    () => sl<LocalItemRepository>(),
  );
}
