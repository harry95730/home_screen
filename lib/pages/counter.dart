import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:suraj/functions/home_widget_data_functions.dart';

typedef UpdateTextCallback = void Function(String number);

/// The @pragma('vm:entry-point') Notification is required so that the Plugin can find it
@pragma('vm:entry-point')
Future<void> interactiveCallback(Uri? uri) async {
  // Set AppGroup Id. This is needed for iOS Apps to talk to their WidgetExtensions
  await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');

  String val = uri.toString().split('_')[1];
  val = Uri.decodeComponent(val);

  if (uri?.host.split('_')[0] == 'increment') {
    await _incremenBac(val);
  } else if (uri?.host.split('_')[0] == 'clear') {
    await _clear(val);
  } else if (uri?.host.split('_')[0] == 'decrement') {
    await _decremenBac(val);
  } else if (uri?.host.split('_')[0] == 'stepdecrement') {
    await _stepdecremenBac(val);
  } else if (uri?.host.split('_')[0] == 'stepincrement') {
    await _stepincremenBac(val);
  }
}

Future<int> value(String countKey) async {
  var mapdata = await HomeWidget.getWidgetData(countKey);
  if (mapdata != null) {
    Map<String, dynamic> individualhabitmapdata = json.decode(mapdata);
    DateTime today = DateTime.now();
    String key = Functions().getFormattedDate(today);
    return individualhabitmapdata[key];
  }
  final value =
      await HomeWidget.getWidgetData<int>('${countKey}nil', defaultValue: 0);
  return value!;
}

Future<int> _stepvalue(String countKey) async {
  final value = await HomeWidget.getWidgetData<int>('${countKey}stepsize',
      defaultValue: 1);
  return value!;
}

Future<int> _incremenBac(String countKey) async {
  final oldValue = await value(countKey);
  final stepValue = await _stepvalue(countKey);
  final newValue = oldValue + stepValue;
  await _sendAndUpdate(countKey, newValue);
  return newValue;
}

Future<int> _stepincremenBac(String countKey) async {
  final stepValue = await _stepvalue(countKey);
  final newValue = stepValue + 1;
  await _sendAndUpdatestepsize(countKey, newValue);
  return newValue;
}

Future<int> _decremenBac(String countKey) async {
  final oldValue = await value(countKey);
  final stepValue = await _stepvalue(countKey);
  final newValue = oldValue - stepValue;
  await _sendAndUpdate(countKey, newValue);
  return newValue;
}

Future<int> _stepdecremenBac(String countKey) async {
  final stepValue = await _stepvalue(countKey);
  final newValue = stepValue - 1;
  await _sendAndUpdatestepsize(countKey, newValue);
  return newValue;
}

/// Clears the saved Counter Value
Future<void> _clear(String countKey) async {
  await _sendAndUpdate(countKey, 0);
}

/// Stores [value] in the Widget Configuration
Future<void> _sendAndUpdate(String countKey, int value) async {
  var mapdata = await HomeWidget.getWidgetData(countKey);
  if (mapdata != null) {
    Map<String, dynamic> individualhabitmapdata = json.decode(mapdata);
    DateTime today = DateTime.now();
    String key = Functions().getFormattedDate(today);

    individualhabitmapdata[key] = value;
    Functions().savetags(individualhabitmapdata, countKey);
  }

  await HomeWidget.updateWidget(
    androidName: 'NewAppWidget',
    iOSName: 'CounterWidget',
  );
}

Future<void> _sendAndUpdatestepsize(String countKey, [int? value]) async {
  await HomeWidget.saveWidgetData('${countKey}stepsize', value);
  await HomeWidget.updateWidget(
    androidName: 'NewAppWidget',
    iOSName: 'CounterWidget',
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.updateText,
  });
  final UpdateTextCallback updateText;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  TextEditingController textController = TextEditingController();
  int? counterValue;
  int? stepvalue;
  int stepsize = -1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    counterValue =
        await HomeWidget.getWidgetData<int>(widget.title, defaultValue: 0);
    stepvalue = await HomeWidget.getWidgetData<int>('${widget.title}stepsize',
        defaultValue: 1);
    textController.text = stepvalue.toString();
  }

  Future<void> _increment() async {
    await _incremenBac(widget.title);
    setState(() {});
  }

  Future<void> _decrement() async {
    await _decremenBac(widget.title);
    setState(() {});
  }

  Future<void> _clear_() async {
    await _clear(widget.title);
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 1,
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 35.0, left: 35.0, right: 45.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder<int>(
                        future: value(widget.title),
                        builder: (_, snapshot) => Column(
                          children: [
                            Text(
                              (snapshot.data ?? 0).toString(),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: IconButton(
                      onPressed: () async {
                        await _sendAndUpdate(widget.title, 0);
                        await _sendAndUpdatestepsize(widget.title, null);
                        widget.updateText(widget.title);
                      },
                      icon: const Icon(Icons.clear),
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 45.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'stepsize',
                    style: TextStyle(fontSize: 24),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 100,
                        child: FutureBuilder<int>(
                          future: _stepvalue(widget.title),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              textController.text =
                                  snapshot.data?.toString() ?? '1';

                              return TextField(
                                controller: textController,
                                decoration: InputDecoration(
                                  hintText: '1',
                                  contentPadding:
                                      const EdgeInsets.only(left: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (textController.text.isNotEmpty) {
                                        stepsize =
                                            int.parse(textController.text);
                                        _sendAndUpdatestepsize(widget.title,
                                            int.parse(textController.text));
                                        setState(() {
                                          textController.text =
                                              stepsize.toString();
                                        });
                                      } else {
                                        _sendAndUpdatestepsize(widget.title, 1);
                                        textController.text = '1';
                                        stepsize = -1;
                                      }
                                      FocusScope.of(context).unfocus();
                                    },
                                    icon: const Icon(
                                      Icons.add_task,
                                      size: 18,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: _clear_,
                  icon: const Icon(Icons.refresh),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
