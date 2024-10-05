import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_update_todo.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListPage(),
    );
  }
}

class TodoItem {
  int id;
  String title;
  String description;
  bool completed;

  TodoItem({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
    };
  }
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<TodoItem> _todoItems = [];
  
  Future<void> fetchTodos() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/todos/'));
    if (response.statusCode == 200) {
      final List<dynamic> todoJson = json.decode(response.body);
      setState(() {
        _todoItems = todoJson.map((json) => TodoItem.fromJson(json)).toList();
      });
    } else {
      setState(() {
        _todoItems = [];
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (context, index) {
          final item = _todoItems[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.description),
            trailing: Checkbox(
              value: item.completed,
              onChanged: (bool? value) {
                setState(() {
                  item.completed = value ?? false;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUpdateTodoPage()),
          );
          if (result == true) {
            fetchTodos();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
