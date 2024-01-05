import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suraj/commonClassDecoration/measurable_yesno.dart';
import 'package:analog_clock_picker/analog_clock_picker.dart';
import 'package:suraj/functions/home_widget_data_functions.dart';
import 'package:suraj/functions/tagspage.dart';
import 'package:suraj/pages/home_page.dart';
import 'package:textfield_tags/textfield_tags.dart';

class YesorNo extends StatefulWidget {
  const YesorNo({super.key});

  @override
  State<YesorNo> createState() => _YesorNoState();
}

class _YesorNoState extends State<YesorNo> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController questioncontroller = TextEditingController();
  TextEditingController notescontroller = TextEditingController();
  AnalogClockController analogClockController = AnalogClockController();
  AnalogClockController confirmationClockController = AnalogClockController();
  TextfieldTagsController tagcontroller = TextfieldTagsController();
  bool homeWidgetSwitch = false;
  List<String> tags = [];
  String remaindertimeoroff = 'Off';
  String remainderdays = 'Everyday';
  String frequency = 'Everyday';
  ColorSwatch? _tempMainColor;
  Color? _tempShadeColor;
  ColorSwatch? _mainColor = Colors.blue;
  Color? _shadeColor = Colors.blue[800];

  Map<String, bool> mar = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': true,
    'Sunday': true,
  };
  Map<String, bool> mar1 = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': true,
    'Sunday': true,
  };
  void weekcall(String x) {
    if (x == 'true') {
      setState(() {
        remainderdays = Deco().star(mar);
        mar1 = mar;
      });
    } else {
      setState(() {
        mar = mar1;
      });
    }
  }

  void checkstate(String x) {
    if (x == 'true') {
      setState(() {
        remaindertimeoroff =
            DateFormat("hh:mm a").format(analogClockController.value);
        confirmationClockController.value = analogClockController.value;
      });
    } else {
      setState(() {
        remaindertimeoroff = 'Off';
      });
    }
  }

  void status() {
    if (remaindertimeoroff != 'Off') {
      setState(() {
        if (analogClockController.value != confirmationClockController.value) {
          analogClockController.value = confirmationClockController.value;
        }
      });
    }
  }

  void maincolass() {
    setState(() {
      _mainColor = _tempMainColor;
    });
  }

  void shadecolass() {
    setState(() {
      _shadeColor = _tempShadeColor;
    });
  }

  void temp(Color color) {
    setState(() {
      _tempShadeColor = color;
    });
  }

  void maincolor(ColorSwatch? color) {
    _tempMainColor = color;
  }

  void changestatus(bool s) {
    setState(() {
      homeWidgetSwitch = s;
    });
  }

  bool savingtheitem() {
    Map harry = {
      "type": "measurable",
      "switch": homeWidgetSwitch,
      "name": namecontroller.text,
      "question": questioncontroller.text,
      "remainder": remaindertimeoroff,
      "selectDays": remainderdays,
      "notes": notescontroller.text,
      "shadecolor": _shadeColor.toString(),
      "maincolor": _mainColor.toString(),
      "frequency": "frequency"
    };
    if (namecontroller.text.isNotEmpty) {
      namecontroller.text = namecontroller.text.trim();
      for (var element in mylist) {
        if (element == namecontroller.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('name already exists'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
      }
      Functions().savetags(harry, '${namecontroller.text}data');
      Functions().initializationofhabit(namecontroller.text, "yesOrNo");
      mylist.add(namecontroller.text);
      Functions().savedata(mylist, 'myStringList');
      List<String>? mylis = tagcontroller.getTags;
      if (mylis != null) {
        for (var i in mylis) {
          if (pickLanguage.contains(i) && i != 'all') {
            retrievedMap[i].add(namecontroller.text);
          } else if (i != 'all') {
            pickLanguage.add(i);
            retrievedMap[i] = [namecontroller.text];
          }
        }
      }
      Functions().savetags(retrievedMap, 'mapKey');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Item saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create habit'),
        actions: [
          Deco().switchBar(context, homeWidgetSwitch, changestatus),
          Deco().saveBar(context, savingtheitem),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                      flex: 9,
                      child: Deco()
                          .textfil(namecontroller, 'e.g Exercise', 'Name')),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                      child: InkWell(
                          onTap: () {
                            Deco().openColorPicker(context, temp, maincolor,
                                _mainColor, maincolass, shadecolass);
                          },
                          child: _shadeColor != null
                              ? Deco().colorfil('Color', _shadeColor!)
                              : Deco().colorfil('Color', _mainColor!)),
                    ),
                  ),
                ],
              ),
            ),
            Deco().textfil(
                questioncontroller, 'e.g Did you exercise today?', 'Question'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Deco().emptyfil('Select tags'),
                  Positioned(
                    top: 5,
                    left: 18,
                    bottom: 5,
                    right: 18,
                    child: Tag().tagsfunction(tagcontroller, tags),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Deco().frequencyfil(
                'Frequency',
                frequency,
                context,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Deco().clockfil('Remainder', remaindertimeoroff, context,
                  analogClockController, checkstate, status),
            ),
            remaindertimeoroff != 'Off'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Deco().extendclockfield(
                        'Select Days', remainderdays, context, mar, weekcall),
                  )
                : Container(),
            Deco().textfil(notescontroller, '(Optional)', 'Notes'),
          ],
        ),
      ),
    );
  }
}
