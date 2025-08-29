import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/list_provider.dart';
import '../../../../../model/todo_dm.dart';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';
import '../widgets/my_textfield.dart';


class AddBottomSheet extends StatefulWidget {
  @override
  State<AddBottomSheet> createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late ListProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * .4,
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Add new task",
            textAlign: TextAlign.center,
            style: AppTheme.bottomSheetTitleTextStyle,
          ),
          const SizedBox(height: 8),
          MyTextField(controller: titleController, hintText: "Enter task title"),
          const SizedBox(height: 8),
          MyTextField(
              controller: descriptionController,
              hintText: "Enter task description"),
          const SizedBox(height: 22),
          const Text(
            "Select date",
            textAlign: TextAlign.start,
            style: AppTheme.bottomSheetTitleTextStyle,
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: showMyDatePicker,
            child: Text(
              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              textAlign: TextAlign.center,
              style: AppTheme.bottomSheetTitleTextStyle.copyWith(
                  color: AppColors.lightBlack, fontSize: 16),
            ),
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: addTaskLocally, child: const Text("Add")),
        ],
      ),
    );
  }

  void addTaskLocally() async {
    TodoDM todo = TodoDM(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
      isDone: false,
    );
    provider.saveTodoLocally(todo);
    Navigator.pop(context);
  }

  void showMyDatePicker() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null) {
      selectedDate = picked;
      setState(() {});
    }
  }
}
