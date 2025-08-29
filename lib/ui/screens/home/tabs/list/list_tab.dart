import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../providers/list_provider.dart';
import '../../../../utils/app_colors.dart';
import '../../todo_widget.dart';

class ListTab extends StatefulWidget {
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
                        color: AppColors.white,
                        shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        color: AppColors.lightBlack,
                        shape: BoxShape.circle),
                    defaultTextStyle: TextStyle(color: AppColors.primiary),
                    weekendTextStyle: TextStyle(color: AppColors.primiary),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: provider.todos.length,
            itemBuilder: (_, index) => TodoWidget(provider.todos[index]),
          ),
        ),
      ],
    );
  }
}
