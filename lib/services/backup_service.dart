import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/todo_dm.dart';

class BackupService {
  /// 🟢 Export: حفظ نسخة من التاسكات في ملف JSON
  static Future<File> exportTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosString = prefs.getString("todos") ?? "[]";

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/backup_todos.json");

    // ✅ اكتب بصيغة JSON مرتبة
    final jsonData = json.decode(todosString);
    final prettyJson = const JsonEncoder.withIndent("  ").convert(jsonData);

    await file.writeAsString(prettyJson);
    return file;
  }

  /// 🟢 Import: استرجاع التاسكات من ملف JSON
  static Future<List<TodoDM>> importTodos(File file) async {
    try {
      final content = await file.readAsString();

      final List decoded = json.decode(content);
      List<TodoDM> importedTasks =
      decoded.map((e) => TodoDM.fromJson(e)).toList();

      // ✅ خزّنها مؤقتاً في SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("todos", json.encode(decoded));

      return importedTasks;
    } catch (e) {
      // لو في مشكلة بالملف، رجّع ليستة فاضية
      print("❌ Error while importing: $e");
      return [];
    }
  }
}
