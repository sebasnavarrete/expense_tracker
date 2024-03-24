import 'package:expense_tracker/screens/accounts_screen.dart';
import 'package:expense_tracker/screens/categories_screen.dart';
import 'package:expense_tracker/screens/expenses_screen.dart';
import 'package:expense_tracker/screens/reports_screen.dart';
import 'package:expense_tracker/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(int index) {
    Widget route = const AccountsScreen();
    Navigator.of(context).pop();
    if (index == 2) {
      route = const CategoriesScreen();
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => route),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const ExpensesScreen();
    var activePageTitle = 'Expenses';
    if (_selectedPageIndex == 1) {
      activePage = const ReportsScreen();
      activePageTitle = 'Reports';
    }
    return Scaffold(
      body: Center(
        child: activePage,
      ),
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        //type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}
