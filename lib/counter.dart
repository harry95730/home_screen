import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

/// The @pragma('vm:entry-point') Notification is required so that the Plugin can find it
@pragma('vm:entry-point')
Future<void> interactiveCallback(Uri? uri) async {
  // Set AppGroup Id. This is needed for iOS Apps to talk to their WidgetExtensions
  await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');

  String val = uri.toString().split('_')[1];
  if (uri?.host.split('_')[0] == 'increment') {
    await _incremenBac(val);
  } else if (uri?.host.split('_')[0] == 'clear') {
    await _clear(val);
  }
}

/// Gets the currently stored Value
Future<int> _value(String countKey) async {
  final value = await HomeWidget.getWidgetData<int>(countKey, defaultValue: 0);
  return value!;
}
Future<int> _incremenBac(String countKey) async {
  final oldValue = await _value(countKey);
  final newValue = oldValue + 1;
  await _sendAndUpdate(countKey, newValue);
  return newValue;
}

/// Clears the saved Counter Value
Future<void> _clear(String countKey) async {
  await _sendAndUpdate(countKey, null);
}

/// Stores [value] in the Widget Configuration
Future<void> _sendAndUpdate(String countKey, [int? value]) async {
  await HomeWidget.saveWidgetData(countKey, value);
  await HomeWidget.updateWidget(
    iOSName: 'CounterWidget',
    androidName: 'NewAppWidget',
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int? counterValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    counterValue =
        await HomeWidget.getWidgetData<int>(widget.title, defaultValue: 0);
    setState(() {});
  }

  Future<void> _increment() async {
    await _incremenBac(widget.title);
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
    return Card(
      elevation: 4, // Adjust the elevation as desired
      margin: EdgeInsets.all(16), // Padding around the card
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder<int>(
              future: _value(widget.title),
              builder: (_, snapshot) => Column(
                children: [
                  Text(
                    (snapshot.data ?? 0).toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: _increment,
                  icon: Icon(Icons.add),
                  color: Colors.green, // Change the color here
                ),
                IconButton(
                  onPressed: _clear_,
                  icon: Icon(Icons.refresh),
                  color: Colors.blue, // Change the color here
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                  color: Colors.red, // Change the color here
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
