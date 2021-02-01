import 'dart:convert';

import 'package:SimpleToDoList/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:SimpleToDoList/class/input_dropdown.dart';
import 'package:SimpleToDoList/class/todo_file_process.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  DateTime currentDate = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();

  // File Processor Object
  ToDoFileProcess fileProcess = ToDoFileProcess();

  String todoTitle = '';

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

  Future<Null> _addTodo() async {
    try {
      List<Map> list = [];
      int lastID = 0;

      // Read Exist TodoList
      String todoStr = await fileProcess.readTodo();

      if (todoStr != '{}' && todoStr != 'fail') {
        var jsonData = jsonDecode(todoStr);

        for (var item in jsonData) {
          Map<String, dynamic> existTodo = {
            'id': item['id'],
            'title': item['title'],
            'date': item['date'],
            'time': item['time'],
            'status': item['status']
          };
          list.add(existTodo);
          lastID = int.parse(item['id']);
        }

        lastID += 1;
      }

      Map<String, dynamic> data = {
        "id": lastID.toString(),
        "title": todoTitle,
        "date": currentDate.toString(),
        "time": timeOfDay.format(context),
        'status': 'await',
      };

      list.add(data);

      var todo = jsonEncode(list);

      // Write Json to File
      fileProcess.writeTodo(todo.toString());

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyToDoList(
                    title: 'My ToDo List',
                  )));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.bodyText2;

    RaisedButton addButton = RaisedButton(
      onPressed: () {
        _addTodo();
      },
      color: Colors.green,
      child: Text(
        'Add New',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
    );

    RaisedButton cancelButton = RaisedButton(
      onPressed: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyToDoList(
                      title: 'My ToDo List',
                    )))
      },
      color: Colors.red,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: Text(
        'Cancel',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );

    TextField inputToDo = TextField(
      decoration: InputDecoration(
        hintText: 'Your ToDo',
        helperText: 'กรอกรายการที่ต้องทำของคุณ',
        // border: const OutlineInputBorder(),
      ),
      onChanged: (text) {
        todoTitle = text;
      },
    );

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
                  addButton,
                  cancelButton,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
