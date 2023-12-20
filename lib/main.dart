// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:suraj/home_page.dart';
import 'counter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');

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
          useMaterial3: false,
        ),
        home: const Start());
  }
}
