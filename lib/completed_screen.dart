import 'dart:convert';

import 'package:SimpleToDoList/class/todo_file_process.dart';
import 'package:SimpleToDoList/todo_detail.dart';
import 'package:SimpleToDoList/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BusinessScreen extends StatefulWidget {
  @override
  _BusinessScreenState createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  // File Processor Object
  ToDoFileProcess fileProcess = ToDoFileProcess();

  var jsonData;
  List<todoObject> todoList;

  Future<String> _getTodoList() async {
    todoList = [];

    String todoStr = await fileProcess.readTodo();
    if (todoStr != '{}' && todoStr != 'fail') {
      jsonData = json.decode(todoStr);

      for (var item in jsonData) {
        if (item['status'] == 'completed') {
          todoObject dotoItem = todoObject(int.parse(item['id']), item['title'],
              item['date'], item['time'], item['status']);

          todoList.add(dotoItem);
        }
      }
    }

    return "successed";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getTodoList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.separated(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: ListTile(
                    title: Text("${todoList[index].title}"),
                    subtitle: Text(
                        "${DateFormat.yMMMd().format(DateTime.parse(todoList[index].date))}, ${todoList[index].time}"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                todoDetail(todoID: todoList[index].id)));
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 3,
                  color: Colors.grey[400],
                );
              },
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
    );
  }
}
