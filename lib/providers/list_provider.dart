import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/todo_dm.dart';

enum TaskFilter { all, completed, uncompleted }

class ListProvider extends ChangeNotifier {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  List<TodoDM> _allTodos = [];
  List<TodoDM> todos = [];
  DateTime selectedDate = DateTime.now();
  TaskFilter filter = TaskFilter.all;

  Future<void> getTodosFromLocal() async {
    _allTodos.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      List jsonList = json.decode(todosString);
      for (var item in jsonList) {
        TodoDM todo = TodoDM.fromJson(item);
        if (todo.date.year == selectedDate.year &&
            todo.date.month == selectedDate.month &&
            todo.date.day == selectedDate.day) {
          _allTodos.add(todo);
        }
      }
    }
    applyFilter();
  }

  Future<void> saveTodoLocally(TodoDM todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    List jsonList = todosString != null ? json.decode(todosString) : [];
    jsonList.add(todo.toJson());
    await prefs.setString('todos', json.encode(jsonList));

    _allTodos.add(todo);
    applyFilter();

    // ✅ جبنا الاندكس الحقيقي بعد ما اتعمل الفلتر
    final index = todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      listKey.currentState?.insertItem(index);
    }
  }

  Future<void> updateTodo(TodoDM updatedTodo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = _allTodos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _allTodos[index] = updatedTodo;
    }
    List jsonList = _allTodos.map((e) => e.toJson()).toList();
    await prefs.setString('todos', json.encode(jsonList));
    applyFilter();
  }

  Future<void> deleteTodo(TodoDM todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = _allTodos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      final removed = _allTodos.removeAt(index);
      applyFilter();

      // ✅ هنا لازم نجيب الاندكس من todos بعد التصفية
      final removedIndex = todos.indexWhere((t) => t.id == removed.id);
      if (removedIndex != -1) {
        listKey.currentState?.removeItem(
          removedIndex,
              (context, animation) => SizeTransition(
            sizeFactor: animation,
            child: ListTile(title: Text(removed.title)),
          ),
        );
      }

      List jsonList = _allTodos.map((e) => e.toJson()).toList();
      await prefs.setString('todos', json.encode(jsonList));
    }
  }

  /// 🟢 دالة استيراد Tasks (Import)
  Future<void> importTasks(List<TodoDM> importedTasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // هات الموجود
    String? todosString = prefs.getString('todos');
    List jsonList = todosString != null ? json.decode(todosString) : [];

    // ضيف الجديد
    for (var task in importedTasks) {
      jsonList.add(task.toJson());
      _allTodos.add(task);
    }

    // خزّنهم تاني
    await prefs.setString('todos', json.encode(jsonList));

    // Refresh
    applyFilter();
  }

  void applyFilter() {
    if (filter == TaskFilter.all) {
      todos = List.from(_allTodos);
    } else if (filter == TaskFilter.completed) {
      todos = _allTodos.where((t) => t.isDone).toList();
    } else {
      todos = _allTodos.where((t) => !t.isDone).toList();
    }
    notifyListeners();
  }

  void changeFilter(TaskFilter newFilter) {
    filter = newFilter;
    applyFilter();
  }
}
