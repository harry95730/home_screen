import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:suraj/functions/home_widget_data_functions.dart';
import 'package:flutter/services.dart';

class SingleItem extends StatefulWidget {
  final String name;
  final ScrollController controller;
  const SingleItem({
    super.key,
    required this.name,
    required this.controller,
  });

  @override
  State<SingleItem> createState() => _SingleItemState();
}

class _SingleItemState extends State<SingleItem> {
  Map<String, dynamic> individualhabitmapdata = {};
  List<String> keys = [];
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    dateandtime();
    previousdata();
  }

  void dateandtime() {
    DateTime today = DateTime.now();
    for (int i = 0; i <= 29; i++) {
      DateTime pastDate = today.subtract(Duration(days: i));
      keys.add(Functions().getFormattedDate(pastDate));
    }
    setState;
  }

  void previousdata() async {
    var mapdata = await HomeWidget.getWidgetData(widget.name);
    if (mapdata != null) {
      individualhabitmapdata = json.decode(mapdata);
      setState(() {
        keys = individualhabitmapdata.keys.toList();
      });
    }
    setState(() {
      isloading = false;
    });
  }

  Future<void> dialogueboxForMeasurable(
      BuildContext context, int index, int textdata) async {
    TextEditingController numbercontroller = TextEditingController();
    numbercontroller.text = textdata.toString();

    var r = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(widget.name.toUpperCase(),
                        style: const TextStyle(fontSize: 20)),
                  ),
                  TextField(
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    controller: numbercontroller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(6, 10, 0, 0),
                      hintText: 'Enter number',
                      suffixIcon: TextButton(
                        onPressed: () {
                          int? parsedNumber =
                              int.tryParse(numbercontroller.text);
                          if (parsedNumber != null) {
                            setState(() {
                              individualhabitmapdata[keys[index]] =
                                  parsedNumber;
                            });
                          } else {
                            setState(() {
                              individualhabitmapdata[keys[index]] = 0;
                            });
                          }
                          Navigator.pop(context, parsedNumber);
                        },
                        child: const Text("save"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    if (r is int) {
      await Functions().savetags(individualhabitmapdata, widget.name);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2 * MediaQuery.of(context).size.width / 3,
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: widget.controller,
        itemCount: keys.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 50,
            child: Center(
              child: isloading
                  ? const CircularProgressIndicator()
                  : widget.name == ''
                      ? Text(keys[index])
                      : individualhabitmapdata[keys[index]] is int
                          ? InkWell(
                              onTap: () async {
                                await dialogueboxForMeasurable(context, index,
                                    individualhabitmapdata[keys[index]]);
                              },
                              child: SizedBox(
                                width: 50,
                                child: Center(
                                  child: Text(
                                      '${individualhabitmapdata[keys[index]]}'),
                                ),
                              ),
                            )
                          : individualhabitmapdata[keys[index]] is bool &&
                                  individualhabitmapdata[keys[index]]
                              ? InkWell(
                                  onTap: () async {
                                    setState(() {
                                      individualhabitmapdata[keys[index]] =
                                          !individualhabitmapdata[keys[index]];
                                    });
                                    await Functions().savetags(
                                        individualhabitmapdata, widget.name);
                                  },
                                  child: Icon(CupertinoIcons.checkmark_alt,
                                      color: Colors.blue[500]),
                                )
                              : InkWell(
                                  onTap: () async {
                                    setState(() {
                                      individualhabitmapdata[keys[index]] =
                                          !individualhabitmapdata[keys[index]];
                                    });
                                    await Functions().savetags(
                                        individualhabitmapdata, widget.name);
                                  },
                                  child: Icon(CupertinoIcons.clear_thick,
                                      color: Colors.grey[500]),
                                ),
            ),
          );
        },
      ),
    );
  }
}
