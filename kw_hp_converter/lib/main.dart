import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LM-Aufgabe 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("LM-Aufgabe 1"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: const <Widget>[
                Text(
                  "Einheitenumwandlung",
                  style: TextStyle(color: Colors.black45),
                ),
                ConvertWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConvertWidget extends StatefulWidget {
  const ConvertWidget({super.key});

  @override
  State<ConvertWidget> createState() => _ConvertWidgetState();
}

class _ConvertWidgetState extends State<ConvertWidget> {
  double hp = 0;
  double kw = 0;

  void convert() {
    setState(() {
      kw = hp * 0.735499;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 90,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'HP',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    try {
                      hp = double.parse(value);
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text('PS ='),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text("${(kw * 10).round() / 10} kW"),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () {
                convert();
              },
              child: const Text("Umwandeln"),
            ),
          )
        ],
      ),
    );
  }
}
