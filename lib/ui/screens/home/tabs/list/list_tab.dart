import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../providers/list_provider.dart';
import '../../../../utils/app_colors.dart';
import '../../todo_widget.dart';

class ListTab extends StatefulWidget {
  final String searchQuery;
  const ListTab({super.key, this.searchQuery = ""});

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  late ListProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getTodosFromLocal();
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);

    // 🟢 فلترة التاسكات
    final filteredTodos = provider.todos.where((task) {
      return task.title.toLowerCase().contains(widget.searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .28,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(flex: 3, child: Container(color: AppColors.primiary)),
                  Expanded(flex: 7, child: Container(color: AppColors.accent)),
                ],
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: TableCalendar(
                  focusedDay: provider.selectedDate,
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  calendarFormat: CalendarFormat.week,
                  selectedDayPredicate: (day) =>
                      isSameDay(provider.selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    provider.selectedDate = selectedDay;
                    provider.getTodosFromLocal();
                  },
                  headerVisible: false,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: AppColors.white, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        color: AppColors.lightBlack, shape: BoxShape.circle),
                    defaultTextStyle: TextStyle(color: AppColors.primiary),
                    weekendTextStyle: TextStyle(color: AppColors.primiary),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: filteredTodos.isEmpty
              ? const Center(
            child: Text(
              "No tasks found",
              style: TextStyle(fontSize: 16),
            ),
          )
              : AnimatedList(
            key: provider.listKey,
            initialItemCount: filteredTodos.length,
            itemBuilder: (context, index, animation) {
              final todo = filteredTodos[index];
              return SizeTransition(
                sizeFactor: animation,
                child: TodoWidget(todo),
              );
            },
          ),
        ),
      ],
    );
  }
}
