import 'dart:convert';
import 'dart:io';

import 'package:nyxx/nyxx.dart';

class DataUtil {
  static String dataPath() {
    return "./Data/";
  }

  static String userFilePath(Snowflake userId) {
    return dataPath() + userId.toString() + ".json";
  }

  static Future<Map<String, dynamic>> getUserData(Snowflake userId) async {
    var file = File(userFilePath(userId));
    if (await file.exists()) {
      var contents = await file.readAsString();
      return json.decode(contents);
    } else {
      return {"xp": 0.0}; // Default XP value if no file exists
    }
  }

  static Future<void> saveUserData(
      Snowflake userId, Map<String, dynamic> data) async {
    var file = File(userFilePath(userId));
    await file.writeAsString(json.encode(data));
  }
}
