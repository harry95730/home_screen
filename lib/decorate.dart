// ignore_for_file: unrelated_type_equality_checks

import 'package:analog_clock_picker/analog_clock_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:suraj/popup.dart';

class Deco {
  Widget tile(String s1, String s2) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              s1,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 0),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(s2),
          ),
        ));
  }

  Widget titlebar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(12.0),
          side: const BorderSide(width: 2.0, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'SAVE',
            style: TextStyle(fontSize: 14.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget textfil(TextEditingController controller, String s1, String s2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: s1,
          labelText: s2,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void openDialog(String title, Widget content, BuildContext context,
      Function mn, Function ms) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(18.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                mn();
                ms();
              },
              child: const Text('SUBMIT'),
            ),
          ],
        );
      },
    );
  }

  void openColorPicker(BuildContext context, Function temp, Function maincolor,
      ColorSwatch? maColor, Function mn, Function ms) async {
    openDialog(
        "Full Material Color picker",
        MaterialColorPicker(
          colors: fullMaterialColors,
          selectedColor: maColor,
          onColorChange: (color) {
            temp(color);
          },
          onMainColorChange: (color) {
            maincolor(color);
          },
        ),
        context,
        mn,
        ms);
  }

  Widget emptyfil(String s1) {
    return TextField(
      canRequestFocus: false,
      decoration: InputDecoration(
        labelText: s1,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget checktype(String s2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(s2), const Spacer(), const Icon(Icons.arrow_drop_down)],
    );
  }

  Widget colorfil(String s1, Color s2) {
    return Stack(
      children: [
        emptyfil(s1),
        Positioned(
          top: 12,
          left: 10,
          bottom: 10,
          right: 10,
          child: Container(
            color: s2,
          ),
        )
      ],
    );
  }

  Widget clockfil(
      String s1,
      String s2,
      BuildContext context,
      AnalogClockController analogClockController,
      Function checkstate,
      Function status) {
    return Stack(
      children: [
        emptyfil(s1),
        Positioned(
          top: 5,
          left: 18,
          bottom: 5,
          right: 18,
          child: InkWell(
              onTap: () {
                status();
                showClockDialog(context, analogClockController, checkstate);
              },
              child: checktype(s2)),
        )
      ],
    );
  }

  Widget frequencyfil(
    String s1,
    String s2,
    BuildContext context,
  ) {
    return Stack(
      children: [
        emptyfil(s1),
        Positioned(
          top: 5,
          left: 18,
          bottom: 5,
          right: 18,
          child: InkWell(
              onTap: () {
                Fur().frequency(context);
              },
              child: checktype(s2)),
        )
      ],
    );
  }

  Widget extendclockfield(String s1, String s2, BuildContext context,
      Map<String, bool> mar, Function weekcall) {
    return Stack(
      children: [
        emptyfil(s1),
        Positioned(
          top: 5,
          left: 18,
          bottom: 5,
          right: 18,
          child: InkWell(
              onTap: () {
                checkboxes(context, mar, weekcall);
              },
              child: checktype(s2)),
        )
      ],
    );
  }

  void showClockDialog(BuildContext context,
      AnalogClockController analogClockController, Function checkstate) async {
    var r = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  ValueListenableBuilder<DateTime>(
                    valueListenable: analogClockController,
                    builder: (context, value, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(12),
                            child: Text(
                              DateFormat("hh:mm").format(value),
                              style: const TextStyle(
                                fontSize: 50,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              analogClockController.setPeriodType(
                                analogClockController.periodType ==
                                        PeriodType.am
                                    ? PeriodType.pm
                                    : PeriodType.am,
                              );
                            },
                            child: Text(
                              analogClockController.periodType == PeriodType.am
                                  ? "AM"
                                  : "PM",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.blueGrey,
                  ),
                  AnalogClockPicker(
                    clockBackground: Image.asset(
                      "assets/images.jpeg",
                    ),
                    clockBackgroundColor: Colors.white,
                    secondHandleColor: Colors.transparent,
                    minutesHandleColor: Colors.black,
                    hourHandleColor: Colors.orange,
                    controller: analogClockController,
                    size: MediaQuery.of(context).size.width * 0.68,
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.blueGrey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('false');
                          },
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'true');
                          },
                          child: const Text('SAVE'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
    if (r == 'true' || r == 'false') {
      checkstate(r);
    }
  }

  String star(Map<String, bool> x) {
    String y = '';
    if (x['Monday']!) {
      y += 'Mon,';
    }
    if (x['Tuesday']!) {
      y += 'Tue,';
    }
    if (x['Wednesday']!) {
      y += 'Wed,';
    }
    if (x['Thursday']!) {
      y += 'Thu,';
    }
    if (x['Friday']!) {
      y += 'Fri,';
    }
    if (x['Saturday']!) {
      y += 'Sat,';
    }
    if (x['Sunday']!) {
      y += 'Sun,';
    }
    if (y == 'Mon,Tue,Wed,Thu,Fri,Sat,Sun,') {
      return 'Everyday';
    }
    if (y.endsWith(',')) {
      y = y.substring(0, y.length - 1);
    }
    return y;
  }

  void checkboxes(BuildContext context, Map<String, bool> daysweek,
      Function weekcall) async {
    var r = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Select Days',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.blueGrey,
                  ),
                  ...daysweek.entries.map((day) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          daysweek[day.key] = !daysweek[day.key]!;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: day.value,
                            onChanged: (bool? newValue) {
                              setState(() {
                                daysweek[day.key] = newValue ?? false;
                              });
                            },
                          ),
                          Text(day.key),
                        ],
                      ),
                    );
                  }).toList(),
                  const Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.blueGrey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('false');
                          },
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'true');
                          },
                          child: const Text('SAVE'),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
    if (r == 'true' || r == 'false') {
      weekcall(r);
    }
  }
}
