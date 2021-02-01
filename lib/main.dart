import 'package:SimpleToDoList/completed_screen.dart';
import 'package:SimpleToDoList/todo_screen.dart';
import 'package:SimpleToDoList/add_new.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyToDoList(title: 'My ToDo List'),
    );
  }
}

class MyToDoList extends StatefulWidget {
  MyToDoList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyToDoListState createState() => _MyToDoListState();
}

class _MyToDoListState extends State<MyToDoList> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _pageOptions = [
    HomeScreen(),
    BusinessScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: _pageOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alarm_rounded),
            label: 'ToDo List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add New',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[400],
        onTap: _onItemTapped,
      ),
    );
    return scaffold;
  }
}
