import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/list_provider.dart';
import '../todo_widget.dart';

class TasksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ListProvider>(context);

    return Column(
      children: [
        // الفلترة
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilterChip(
                label: const Text("All"),
                selected: provider.filter == TaskFilter.all,
                onSelected: (_) {
                  provider.changeFilter(TaskFilter.all);
                },
              ),
              FilterChip(
                label: const Text("Completed"),
                selected: provider.filter == TaskFilter.completed,
                onSelected: (_) {
                  provider.changeFilter(TaskFilter.completed);
                },
              ),
              FilterChip(
                label: const Text("Uncompleted"),
                selected: provider.filter == TaskFilter.uncompleted,
                onSelected: (_) {
                  provider.changeFilter(TaskFilter.uncompleted);
                },
              ),
            ],
          ),
        ),

        // اللستة
        Expanded(
          child: ListView.builder(
            itemBuilder: (_, index) {
              return TodoWidget(provider.todos[index]);
            },
            itemCount: provider.todos.length,
          ),
        ),
      ],
    );
  }
}
