// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rrule_generator/rrule_generator.dart';
import 'package:suraj/functions/classforfunctios.dart';
import 'package:suraj/decorate/decorate.dart';
import 'package:suraj/pages/home_page.dart';
import 'package:suraj/pages/measurable.dart';
import 'package:suraj/pages/yesno.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Fur {
  Future<String> addTodo(BuildContext context, String dest) async {
    TextEditingController textController = TextEditingController();
    TextfieldTagsController controller = TextfieldTagsController();
    textController.text = dest;

    bool? r = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Container(
            margin: const EdgeInsets.only(
                top: 40.0, left: 15, right: 15, bottom: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'NEW CARD',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) {
                    dest = value;
                  },
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel')),
                    TextButton(
                      child: const Text('Add'),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
    if (r != null) {
      if (r) {
        if (textController.text.isNotEmpty) {
          textController.text = textController.text.trim();
          for (var element in mylist) {
            if (element == textController.text) {
              return '';
            }
          }
          mylist.add(textController.text);
          Functions().savedata(mylist, 'myStringList');
          List<String>? mylis = controller.getTags;
          if (mylis != null) {
            for (var i in mylis) {
              if (pickLanguage.contains(i) && i != 'all') {
                retrievedMap[i].add(textController.text);
              } else if (i != 'all') {
                pickLanguage.add(i);
                retrievedMap[i] = [textController.text];
              }
            }
          }
          Functions().savetags();
        }
        return textController.text;
      }
    }
    return '';
  }

  Future<void> showYesNoDialog(BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
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
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  height: 20,
                ),
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const YesorNo()));
      } else if (res == 'a') {
        Navigator.push(context,
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
