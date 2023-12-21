import 'package:flutter/material.dart';
import 'package:suraj/classforfunctios.dart';
import 'package:textfield_tags/textfield_tags.dart';

class Tag {
  Widget tagsfunction(TextfieldTagsController controller, List<String> tags) {
    double distanceToField = 1.0;

    return Autocomplete<String>(
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
                        vertical: 15.0, horizontal: 5),
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
          inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
            return ((context, sc, tags, onTagDelete) {
              return Row(
                children: [
                  Expanded(
                    flex: tags.isNotEmpty ? 5 : 0,
                    child: SingleChildScrollView(
                      controller: sc,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: tags.map((String tag) {
                            return Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Color.fromARGB(255, 74, 137, 92),
                              ),
                              margin: const EdgeInsets.only(right: 6.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '#$tag',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 4.0),
                                  InkWell(
                                    child: const Icon(
                                      Icons.cancel,
                                      size: 14.0,
                                      color: Color.fromARGB(255, 233, 233, 233),
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
                    flex: tags.isNotEmpty ? 5 : 10,
                    child: Padding(
                      padding: tags.isNotEmpty
                          ? const EdgeInsets.only(left: 8.0)
                          : const EdgeInsets.only(left: 0.0),
                      child: TextField(
                        controller: tec,
                        focusNode: fn,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 0.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 0.0),
                          ),
                          hintText: controller.hasTags
                              ? 'More tags...'
                              : "Enter tag...",
                          errorText: error,
                          prefixIconConstraints:
                              BoxConstraints(maxWidth: distanceToField * 0.74),
                        ),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.clearTags();
                    },
                    child: const Icon(Icons.clear, color: Colors.grey),
                  ),
                ],
              );
            });
          },
        );
      },
    );
  }
}
