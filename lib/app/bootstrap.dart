import 'package:hive_flutter/hive_flutter.dart';

import 'core/storage/hive_boxes.dart';
import '../database/seed_database.dart';

Future<void> bootstrap() async {
  await Hive.initFlutter();
  await Hive.openBox(HiveBoxes.app);
  await Hive.openBox(HiveBoxes.orders);
  await Hive.openBox(HiveBoxes.addresses);
  await SeedDatabase.seed();
}
