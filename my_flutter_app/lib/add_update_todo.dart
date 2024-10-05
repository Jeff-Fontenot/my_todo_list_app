import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart'; // Import the TodoItem class

class AddUpdateTodoPage extends StatefulWidget {
  final TodoItem? todoItem;

  AddUpdateTodoPage({this.todoItem});

  @override
  _AddUpdateTodoPageState createState() => _AddUpdateTodoPageState();
}

class _AddUpdateTodoPageState extends State<AddUpdateTodoPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late bool completed;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todoItem?.title ?? '');
    descriptionController = TextEditingController(text: widget.todoItem?.description ?? '');
    completed = widget.todoItem?.completed ?? false;
  }

  Future<void> saveTodo() async {
    final todo = TodoItem(
      id: widget.todoItem?.id ?? DateTime.now().millisecondsSinceEpoch,
      title: titleController.text,
      description: descriptionController.text,
      completed: completed,
    );

    final response = widget.todoItem == null
        ? await http.post(
            Uri.parse('http://127.0.0.1:8000/todos/'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(todo.toJson()),
          )
        : await http.put(
            Uri.parse('http://127.0.0.1:8000/todos/${todo.id}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(todo.toJson()),
          );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todoItem == null ? 'Add Todo' : 'Update Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            CheckboxListTile(
              title: Text('Completed'),
              value: completed,
              onChanged: (bool? value) {
                setState(() {
                  completed = value ?? false;
                });
              },
            ),
            ElevatedButton(
              onPressed: saveTodo,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
