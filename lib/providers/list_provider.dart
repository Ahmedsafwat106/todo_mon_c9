import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/todo_dm.dart';

class ListProvider extends ChangeNotifier {
  List<TodoDM> todos = [];
  DateTime selectedDate = DateTime.now();

  getTodosFromLocal() async {
    todos.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      List jsonList = json.decode(todosString);
      for (var item in jsonList) {
        TodoDM todo = TodoDM.fromJson(item);
        if (todo.date.year == selectedDate.year &&
            todo.date.month == selectedDate.month &&
            todo.date.day == selectedDate.day) {
          todos.add(todo);
        }
      }
    }
    notifyListeners();
  }

  saveTodoLocally(TodoDM todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    List jsonList = todosString != null ? json.decode(todosString) : [];
    jsonList.add(todo.toJson());
    await prefs.setString('todos', json.encode(jsonList));
    getTodosFromLocal();
  }
}
