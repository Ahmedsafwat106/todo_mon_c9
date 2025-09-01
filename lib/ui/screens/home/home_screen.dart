import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/app_user.dart';
import '../../../providers/list_provider.dart';
import '../auth/login/login_screen.dart';
import 'tabs/list/list_tab.dart';
import 'tabs/settings/settings_tab.dart';
import '../../bottom_sheets/add_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTabIndex = 0;
  late ListProvider provider;

  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<ListProvider>(context);
    // 🟢 دا يضمن إن التاسكات تتجاب دايمًا أول ما يفتح HomeScreen
    provider.getTodosFromLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search tasks...",
            border: InputBorder.none,
          ),
          onChanged: (_) {
            setState(() {}); // تحديث الشاشة عشان يفلتر
          },
        )
            : Text("${AppUser.currentUser?.username ?? ""}"),
        toolbarHeight: MediaQuery.of(context).size.height * .08,
        actions: [
          if (currentTabIndex == 0) // زرار السيرش يظهر بس في Tasks
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    searchController.clear();
                  }
                  isSearching = !isSearching;
                });
              },
            ),
          InkWell(
            onTap: () async {
              provider.todos.clear();
              AppUser.currentUser = null;
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            child: const Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: currentTabIndex == 0
              ? LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade50],
          )
              : LinearGradient(
            colors: [Colors.grey.shade300, Colors.white],
          ),
        ),
        child: currentTabIndex == 0
            ? ListTab(searchQuery: searchController.text)
            : const SettingsTab(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: AddBottomSheet(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        clipBehavior: Clip.hardEdge,
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() => currentTabIndex = index);
          },
          currentIndex: currentTabIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.checklist), label: "Tasks"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
      ),
    );
  }
}
