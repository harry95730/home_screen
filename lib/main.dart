// ignore_for_file: use_build_context_synchronously

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:suraj/functions/home_widget_data_functions.dart';
import 'package:suraj/pages/home_page.dart';
import 'pages/counter.dart';

Duration timeUntilMidnight() {
  DateTime now = DateTime.now();
  DateTime midnight = DateTime(now.year, now.month, now.day + 1);
  Duration difference = midnight.difference(now);
  return difference;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');

  await AndroidAlarmManager.initialize();
  Duration timeDifference = timeUntilMidnight();

  await AndroidAlarmManager.periodic(
    const Duration(hours: 24),
    0,
    callBackForEveryDay,
    startAt: DateTime.now().add(timeDifference),
  );

  await HomeWidget.registerInteractivityCallback(interactiveCallback);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.light(
          useMaterial3: true,
        ),
        home: const Start());
  }
}
