import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:suraj/functions/home_widget_data_functions.dart';
import 'package:suraj/functions/list_items_in_dialog.dart';
import 'package:suraj/pages/data_table_homepage.dart';

List<String> mylist = [];

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  List<String> mylist1 = [];
  int selectednumber = 0;
  @override
  void initState() {
    super.initState();
    _loadstate();
    f1();
  }

  f1() async {
    await Functions().gettags();
    setState;
  }

  void managingControllers() {
    for (ScrollController x in _controllers) {
      x.addListener(() {
        final double currentOffset = x.position.pixels;
        for (ScrollController y in _controllers) {
          if (y != x) {
            if ((currentOffset - y.position.pixels).abs() >= 0.01) {
              y.jumpTo(currentOffset);
            }
          }
        }
      });
    }
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
            _controllers.add(ScrollController());
          }
          _controllers.add(ScrollController());
          managingControllers();
        });
      }
    }
  }

  void statemanageofchild() {
    setState;
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
    Functions().savetags(retrievedMap, 'mapKey');
  }

  void listoftags(String x, int num) {
    mylist1.clear();
    _controllers.clear();
    if (num == 0) {
      for (var i in mylist) {
        mylist1.add(i);
        _controllers.add(ScrollController());
      }
    } else {
      for (var i in retrievedMap[x]) {
        _controllers.add(ScrollController());
        mylist1.add(i);
      }
    }
    _controllers.add(ScrollController());
    managingControllers();
    setState;
  }

  final List<ScrollController> _controllers = <ScrollController>[];
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
                      listoftags(pickLanguage[index], index);
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
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: mylist1.length + 1,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width / 3) -
                                          1,
                                  height: 55,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: index == 0
                                          ? const Text('')
                                          : Text(mylist1[index - 1]),
                                    ),
                                  ),
                                ),
                                SingleItem(
                                  controller: _controllers[index],
                                  name: index == 0 ? '' : mylist1[index - 1],
                                )
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                              thickness: 1,
                              height: 1,
                            )
                          ],
                        );
                      },
                    )
                  : const Center(
                      child: Text('NO WIDGETS FOUND'),
                    )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Fur().showYesNoDialog(context);
          listoftags(pickLanguage[selectednumber], selectednumber);
        },
        tooltip: 'Add Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
