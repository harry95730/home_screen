import 'dart:math';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'counter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');
  await HomeWidget.registerBackgroundCallback(interactiveCallback);
  runApp(const MyApp());
}




class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light(
          useMaterial3: false,
        ),
        home: Start());
  }
}

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  List<String> mylist = [];

  @override
  void initState() {
    super.initState();
    _loadstate();
  }

  void _loadstate() async {
    var data = await HomeWidget.getWidgetData('myStringList');
    if (data != null) {
      var list = data.split('|');
      setState(() {
        mylist = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: mylist.isNotEmpty
          ? ListView.builder(
              itemCount: mylist.length,
              itemBuilder: (context, index) {
                return MyHomePage(title: mylist[index]);
              },
            )
          : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _addCounter();
          });
        },
        tooltip: 'Add Counter',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addCounter() async {
    // String key = _generateRandomKey();
    String title = await _getTitleFromDialog();
    title=title.trim();
    for (var element in mylist) {
       if(element == title) return;
     }
    setState(() {
      mylist.add(title);
    });

    String formattedString = mylist.join('|');

    // Save the formatted string to HomeWidget with a unique key
    await HomeWidget.saveWidgetData('myStringList', formattedString);
  }


  _getTitleFromDialog() {
    TextEditingController titleController = TextEditingController();

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_circle,
                  size: 40,
                  color: Colors.blue,
                ),
                SizedBox(height: 20),
                Text(
                  'Enter Title',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel')),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        child: Text('Add'),
                        onPressed: () {
                          Navigator.of(context).pop(titleController.text);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
