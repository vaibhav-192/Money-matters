import 'package:hive_flutter/hive_flutter.dart';

class StorageService {

  static Future init()
  async {

    await Hive.initFlutter();

    await Hive.openBox(
      "money",
    );

  }

  static Box get box =>

      Hive.box(
        "money",
      );

}