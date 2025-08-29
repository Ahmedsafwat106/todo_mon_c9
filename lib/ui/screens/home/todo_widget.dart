import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/todo_dm.dart';
import '../../../providers/list_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_theme.dart';

class TodoWidget extends StatelessWidget {
  final TodoDM item;
  TodoWidget(this.item);

  @override
  Widget build(BuildContext context) {
    ListProvider provider = Provider.of(context, listen: false);

    return Slidable(
      key: Key(item.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: .3,
        children: [
          SlidableAction(
            onPressed: (_) async {
              // حذف التودو محليًا
              provider.todos.removeWhere((todo) => todo.id == item.id);

              // حفظ القائمة بعد الحذف في SharedPreferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              List jsonList = provider.todos.map((e) => e.toJson()).toList();
              await prefs.setString('todos', json.encode(jsonList));

              // تحديث الواجهة
              provider.notifyListeners();
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * .12,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            const VerticalDivider(
              thickness: 5,
              color: AppColors.primiary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(item.title, style: AppTheme.taskTitleTextStyle),
                  const SizedBox(height: 12),
                  Text(item.description,
                      style: AppTheme.taskDescriptionTextStyle),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primiary),
              child: const Icon(Icons.check, color: AppColors.white, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}
