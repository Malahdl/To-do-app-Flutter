import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/new_task_page.dart';
import 'package:todo_app/todo_item.dart';

import 'Todo.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do App',
      home: const MyHomePage(title: 'To-do App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FocusNode _focusNode = FocusNode();

  List<Todo> todos = [];

  TextEditingController _controller = TextEditingController();

  String? _task;
  DateTime? _endDate;

  Todo? todo;

  bool isError = false;

  Future<void> saveList(String key, List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, list);
  }

  Future<List<String>> getList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? []; // Empty list if not found
    return list;
  }

  Future<void> removeTask(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  void onAddTask(String newTask, DateTime newDate) async {
    setState(() {
      todo = Todo(id: generateRandomString(6), task: newTask, endDate: newDate);

      todos.add(
        todo!,
      );
      _task = null;
      _endDate = null;
      _controller.text = '';
    });

    await saveList(todo!.id, [
      '${todo!.task}',
      '${todo!.endDate!.year}-${todo!.endDate!.month}-${todo!.endDate!.day}',
      'false',
    ]);

    List<String> ids = [];

    ids = await getList('taskIds');

    ids.add(todo!.id);

    await saveList('taskIds', ids);
  }

  @override
  void initState() {
    setTodoList();
    super.initState();
  }

  void updateErrorState(bool newState) {
    setState(() {
      isError = newState;
    });
  }

  void setTodoList() async {
    List<String> ids = [];
    ids = await getList('taskIds');

    if (ids.isNotEmpty) {
      for (var i = 0; i < ids.length; i++) {
        var todoItem = await getList(ids[i]);
        DateFormat format = DateFormat("yyyy-MM-dd");
        todos.add(Todo(
            id: ids[i],
            task: todoItem[0],
            endDate: format.parse(todoItem[1]),
            isDone: bool.parse(todoItem[2])));
      }
      setState(() {});
    }
  }

  void onCheck(Todo todo, bool newState) async {
    setState(() {
      todo.isDone = newState;
    });

    await saveList(todo.id, [
      todo.task,
      '${todo.endDate!.year}-${todo.endDate!.month}-${todo.endDate!.day}',
      todo.isDone.toString(),
    ]);
  }

  void onRemove(Todo todo) async {
    String tempId = todo.id;
    setState(() {
      todos.remove(todo);
    });

    await removeTask(tempId);

    List<String> ids = [];

    ids = await getList('taskIds');

    ids.remove(tempId);

    await saveList('taskIds', ids);
  }

  String generateRandomString(int length) {
    const allowedChars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    String result = '';
    for (int i = 0; i < length; i++) {
      result += allowedChars[random.nextInt(allowedChars.length)];
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    BuildContext ctx = context;

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 500,
            width: double.infinity,
            child: todos.isEmpty
                ? Center(
                    child: Text(
                      'No Tasks Yet!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      return TodoItem(
                        todo: todos[index],
                        onCheck: onCheck,
                        onRemove: onRemove,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.0),
              ),
            ),
            builder: (context) {
              return NewTaskPage(
                controller: _controller,
                task: _task,
                endDate: _endDate,
                isError: isError,
                onAddTask: onAddTask,
              );
            },
          );
        },
        tooltip: 'Add Task',
        child: const Icon(
          Icons.add,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
