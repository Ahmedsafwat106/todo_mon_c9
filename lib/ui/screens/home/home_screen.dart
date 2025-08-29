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
  final List<Widget> tabs = [ListTab(), SettingsTab()];

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppUser.currentUser?.username ?? ""}"),
        toolbarHeight: MediaQuery.of(context).size.height * .08,
        actions: [
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
      body: tabs[currentTabIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
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
            currentTabIndex = index;
            setState(() {});
          },
          currentIndex: currentTabIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
          ],
        ),
      ),
    );
  }
}
