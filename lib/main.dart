import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:suraj/classforfunctios.dart';
import 'package:suraj/popup.dart';
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

List<String> mylist = [];
List<String> mylist1 = [];

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  int selectednumber = 0;
  @override
  void initState() {
    super.initState();
    _loadstate();
    f1();
  }

  f1() async {
    await Functions().gettags();
    setState(() {});
  }

  void _loadstate() async {
    var data = await HomeWidget.getWidgetData('myStringList');
    if (data != null) {
      if (data.isNotEmpty) {
        var list = data.split('|');
        setState(() {
          mylist = list;
          for (var i in mylist) {
            mylist1.add(i);
          }
        });
      }
    }
  }

  void deleteitem(String number) async {
    for (var i in pickLanguage) {
      if (i != 'all') {
        if (retrievedMap[i] != null && retrievedMap[i].contains(number)) {
          retrievedMap[i].removeWhere((word) => word == number);
        }
      }
    }
    mylist.removeWhere((word) => word == number);

    mylist1.clear();
    if (selectednumber != 0) {
      for (var i in retrievedMap[pickLanguage[selectednumber]]) {
        mylist1.add(i);
      }
    } else {
      for (var i in mylist) {
        mylist1.add(i);
      }
    }
    setState(() {});
    String formattedString = mylist.join('|');

    await HomeWidget.saveWidgetData('myStringList', formattedString);
    Functions().savetags();
  }

  void f(String x, int num) {
    mylist1.clear();
    if (num == 0) {
      for (var i in mylist) {
        mylist1.add(i);
      }
    } else {
      for (var i in retrievedMap[x]) {
        mylist1.add(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: pickLanguage.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectednumber = index;
                      f(pickLanguage[index], index);
                    });
                  },
                  child: Container(
                    height: double.minPositive,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      color: selectednumber != index
                          ? const Color.fromARGB(255, 74, 137, 92)
                          : Colors.amber,
                    ),
                    margin: const EdgeInsets.only(right: 10.0, top: 10.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 4.0),
                    child: Center(
                      child: Text(
                        '#${pickLanguage[index]}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
              flex: 10,
              child: mylist1.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: mylist1.length,
                      itemBuilder: (context, index) {
                        return MyHomePage(
                            title: mylist1[index], updateText: deleteitem);
                      },
                    )
                  : const Center(
                      child: Text('NO WIDGETS FOUND'),
                    )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _addCounter();
          setState(() {});
        },
        tooltip: 'Add Counter',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addCounter() async {
    await Fur().addTodo(context, '');
  }
}
