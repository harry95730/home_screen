// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rrule_generator/rrule_generator.dart';
import 'package:suraj/commonClassDecoration/measurable_yesno.dart';
import 'package:suraj/pages/measurable.dart';
import 'package:suraj/pages/yesno.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

List<String> tags = [];
double distanceToField = 1.0;

class Fur {
  Future<void> showYesNoDialog(BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context, 'b');
                  },
                  child: Deco().tile('Yes or No',
                      'e.g. Did you wake up early today? Did you exercise? Did you play Chess')),
              Container(
                color: Colors.transparent,
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context, 'a');
                },
                child: Deco().tile('Measurable',
                    'e.g. How many miles did you run today? How many pages did you read?'),
              ),
            ],
          ),
        );
      },
    );
    if (res != null) {
      if (res == 'b') {
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => const YesorNo()));
      } else if (res == 'a') {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Measurable()));
      }
    }
  }

  Future<void> pickcolor(BuildContext context, Color selectedColor,
      VoidCallback Function(Color selected) parent) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: selectedColor,
                    onColorChanged: parent,
                    pickerAreaHeightPercent: 0.8,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    TextButton(
                      child: const Text('Done'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> frequency(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          child: RRuleGenerator(
            config: RRuleGeneratorConfig(),
            initialRRule:
                'RRULE:FREQ=WEEKLY;UNTIL=20231211T000000;INTERVAL=1;BYDAY=MO',
            textDelegate: const EnglishRRuleTextDelegate(),
            onChange: (value) {
              //print('value :${value.toString()}');
            },
          ),
        ),
      ),
    );
  }
}
