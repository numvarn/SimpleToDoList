import 'dart:convert';

import 'package:SimpleToDoList/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:SimpleToDoList/class/input_dropdown.dart';

import 'class/todo_file_process.dart';

// ignore: camel_case_types
class todoDetail extends StatefulWidget {
  final todoID;

  const todoDetail({Key key, @required this.todoID}) : super(key: key);
  @override
  _todoDetailState createState() => _todoDetailState();
}

// ignore: camel_case_types
class _todoDetailState extends State<todoDetail> {
  String todoTitle = '';
  String todoStatus = '';

  DateTime currentDate = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();

  TextEditingController _controller;

  // File Processor Object
  ToDoFileProcess fileProcess = ToDoFileProcess();
  List<Map> todoList = [];
  int selectedID;
  double height = 20;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));

    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay chooseTime = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
    );

    if (chooseTime != null) {
      setState(() {
        timeOfDay = chooseTime;
      });
    }
  }

  void _deleteTodo() {
    todoList.removeWhere((element) => element['id'] == selectedID.toString());

    var todo = jsonEncode(todoList);

    fileProcess.writeTodo(todo.toString());

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyToDoList(
                  title: 'My ToDo List',
                )));
  }

  Future<void> _editTodo() async {
    int index = 0;
    for (var item in todoList) {
      if (item['id'] == selectedID.toString()) {
        todoList[index]['title'] = todoTitle;
        todoList[index]['date'] = currentDate.toString();
        todoList[index]['time'] = timeOfDay.format(context);
        break;
      }
      index += 1;
    }

    var todo = jsonEncode(todoList);

    fileProcess.writeTodo(todo.toString());

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyToDoList(
                  title: 'My ToDo List',
                )));
  }

  Future<void> _setCompleted() async {
    int index = 0;
    for (var item in todoList) {
      if (item['id'] == selectedID.toString()) {
        todoList[index]['status'] = 'completed';
        break;
      }
      index += 1;
    }

    var todo = jsonEncode(todoList);

    fileProcess.writeTodo(todo.toString());

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyToDoList(
                  title: 'My ToDo List',
                )));
  }

  Future<void> _setUnCompleted() async {
    int index = 0;
    for (var item in todoList) {
      if (item['id'] == selectedID.toString()) {
        todoList[index]['status'] = 'await';
        break;
      }
      index += 1;
    }

    var todo = jsonEncode(todoList);

    fileProcess.writeTodo(todo.toString());

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyToDoList(
                  title: 'My ToDo List',
                )));
  }

  Future<String> _getTodoFile(int todoID) async {
    // Setup value for one time.
    if (todoList.length == 0) {
      String todoStr = await fileProcess.readTodo();
      var jsonData = json.decode(todoStr);
      for (var item in jsonData) {
        Map<String, dynamic> todoItem = {
          'id': item['id'],
          'title': item['title'],
          'date': item['date'],
          'time': item['time'],
          'status': item['status']
        };

        todoList.add(todoItem);

        if (todoID == int.parse(item['id'])) {
          setState(() {
            selectedID = int.parse(item['id']);
            // Set Controller
            _controller = new TextEditingController(text: item['title']);

            // Set Todo Title
            todoTitle = item['title'];

            // Set Date
            currentDate = DateTime.parse(item['date']);

            // Set status
            todoStatus = item['status'];

            // Set TimeOfDay
            DateTime date = DateFormat.jm().parse(item['time']);
            timeOfDay = TimeOfDay.fromDateTime(date);
          });
        }
      }
    }
    return "successed";
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.bodyText2;

    RaisedButton editButton = RaisedButton(
      onPressed: () {
        _editTodo();
      },
      color: Colors.green,
      child: Text(
        'Edit To Do',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
    );

    RaisedButton completedButton = RaisedButton(
      onPressed: () {
        _setCompleted();
      },
      color: Colors.red,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: Text(
        'Completed',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );

    RaisedButton uncompletedButton = RaisedButton(
      onPressed: () {
        _setUnCompleted();
      },
      color: Colors.red,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: Text(
        'Un-completed',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );

    TextField inputToDo = TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Your ToDo',
        helperText: 'กรอกรายการที่ต้องทำของคุณ',
      ),
      onChanged: (text) {
        todoTitle = text;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo Detail"),
      ),
      body: FutureBuilder(
        future: _getTodoFile(widget.todoID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    inputToDo,
                    SizedBox(
                      height: height,
                    ),
                    InputDropdown(
                      labelText: 'Select Date',
                      valueText: new DateFormat.yMMMd().format(currentDate),
                      valueStyle: valueStyle,
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                    SizedBox(
                      height: height,
                    ),
                    InputDropdown(
                      labelText: 'Select Time',
                      valueText: timeOfDay.format(context),
                      valueStyle: valueStyle,
                      onPressed: () {
                        _selectTime(context);
                      },
                    ),
                    SizedBox(
                      height: height,
                    ),
                    Container(
                      child: ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          editButton,
                          todoStatus != 'completed'
                              ? completedButton
                              : uncompletedButton
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _deleteTodo();
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}
