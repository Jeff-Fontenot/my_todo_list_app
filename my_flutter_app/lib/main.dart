import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _response = '';

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/'));
      if (response.statusCode == 200) {
        setState(() {
          _response = json.decode(response.body)['Hello'];
        });
      } else {
        setState(() {
          _response = 'Failed to load data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
       _response = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Response from FastAPI: $_response'),
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Fetch Data'),
            ),
          ],
        ),
      ),
    );
  }
}
