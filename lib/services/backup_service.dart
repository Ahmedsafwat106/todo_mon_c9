import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupService {
  /// 🟢 Export: حفظ نسخة من التاسكات في ملف JSON
  static Future<File> exportTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosString = prefs.getString("todos") ?? "[]";

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/backup_todos.json");

    await file.writeAsString(todosString);
    return file;
  }

  /// 🟢 Import: استرجاع التاسكات من ملف JSON
  static Future<void> importTodos(File file) async {
    final content = await file.readAsString();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("todos", content);
  }
}
