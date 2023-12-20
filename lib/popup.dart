// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rrule_generator/rrule_generator.dart';
import 'package:suraj/classforfunctios.dart';
import 'package:suraj/decorate.dart';
import 'package:suraj/main.dart';
import 'package:suraj/measurable.dart';
import 'package:suraj/yesno.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

List<String> tags = [];
double distanceToField = 1.0;

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
                Autocomplete<String>(
                  optionsViewBuilder: (context, onSelected, options) {
                    return Material(
                      color: Colors.transparent,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final dynamic option = options.elementAt(index);
                          return Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: InkWell(
                              onTap: () {
                                onSelected(option);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10),
                                child: Text(
                                  '#$option',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 74, 137, 92),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    final inputText = textEditingValue.text.toLowerCase();
                    return pickLanguage.where((String option) {
                      final optionLower = option.toLowerCase();
                      return optionLower.contains(inputText);
                    });
                  },
                  onSelected: (String selectedTag) {
                    controller.addTag = selectedTag;
                  },
                  fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                    return TextFieldTags(
                      textEditingController: ttec,
                      focusNode: tfn,
                      textfieldTagsController: controller,
                      initialTags: tags,
                      textSeparators: const [' ', ','],
                      letterCase: LetterCase.normal,
                      validator: (String tag) {
                        if (controller.getTags!.contains(tag.toLowerCase())) {
                          return 'exists';
                        }
                        return null;
                      },
                      inputfieldBuilder:
                          (context, tec, fn, error, onChanged, onSubmitted) {
                        return ((context, sc, tags, onTagDelete) {
                          return Row(
                            children: [
                              Expanded(
                                flex: tags.isNotEmpty ? 3 : 0,
                                child: SingleChildScrollView(
                                  controller: sc,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: tags.map((String tag) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.0),
                                            ),
                                            color: Color.fromARGB(
                                                255, 74, 137, 92),
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '#$tag',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(width: 4.0),
                                              InkWell(
                                                child: const Icon(
                                                  Icons.cancel,
                                                  size: 14.0,
                                                  color: Color.fromARGB(
                                                      255, 233, 233, 233),
                                                ),
                                                onTap: () {
                                                  onTagDelete(tag);
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList()),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: tec,
                                  focusNode: fn,
                                  decoration: InputDecoration(
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 74, 137, 92),
                                          width: 3.0),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 74, 137, 92),
                                          width: 3.0),
                                    ),
                                    helperText: controller.hasTags
                                        ? ''
                                        : 'Select tags...',
                                    helperStyle: const TextStyle(
                                      color: Color.fromARGB(255, 74, 137, 92),
                                    ),
                                    hintText: controller.hasTags
                                        ? ''
                                        : "Enter tag...",
                                    errorText: error,
                                    prefixIconConstraints: BoxConstraints(
                                        maxWidth: distanceToField * 0.74),
                                  ),
                                  onChanged: onChanged,
                                  onSubmitted: onSubmitted,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.clearTags();
                                },
                                child:
                                    const Icon(Icons.clear, color: Colors.grey),
                              ),
                            ],
                          );
                        });
                      },
                    );
                  },
                ),
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
            onChange: print,
          ),
        ),
      ),
    );
  }

  void frequencyfil() {}
}
