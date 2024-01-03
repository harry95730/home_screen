import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suraj/decorate/decorate.dart';
import 'package:analog_clock_picker/analog_clock_picker.dart';
import 'package:suraj/pages/tagspage.dart';
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
  AnalogClockController confirmationController = AnalogClockController();
  TextfieldTagsController tagcontroller = TextfieldTagsController();
  bool homeWidgetSwitch = false;
  List<String> tags = [];
  String s2 = 'Off';
  String s3 = 'Everyday';
  String s4 = 'Everyday';
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
        s3 = Deco().star(mar);
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
        s2 = DateFormat("hh:mm a").format(analogClockController.value);
        confirmationController.value = analogClockController.value;
      });
    } else {
      setState(() {
        s2 = 'Off';
      });
    }
  }

  void status() {
    if (s2 != 'Off') {
      setState(() {
        if (analogClockController.value != confirmationController.value) {
          analogClockController.value = confirmationController.value;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create habit'),
        actions: [
          Deco().titlebara(context, homeWidgetSwitch, changestatus),
          Deco().titlebar(context),
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
                s4,
                context,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Deco().clockfil('Remainder', s2, context,
                  analogClockController, checkstate, status),
            ),
            s2 != 'Off'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Deco().extendclockfield(
                        'Select Days', s3, context, mar, weekcall),
                  )
                : Container(),
            Deco().textfil(notescontroller, '(Optional)', 'Notes'),
          ],
        ),
      ),
    );
  }
}
