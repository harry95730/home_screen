import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

Map<String, dynamic> retrievedMap = {};
List<String> pickLanguage = <String>[];

@pragma('vm:entry-point')
Future<void> callBackForEveryDay() async {
  var data = await HomeWidget.getWidgetData('myStringList');
  DateTime today = DateTime.now();
  String key = Functions().getFormattedDate(today);
  if (data != null) {
    if (data.isNotEmpty) {
      var listOfTags = data.split('|');
      for (var individualhabit in listOfTags) {
        var mapdata = await HomeWidget.getWidgetData(individualhabit);
        if (mapdata != null) {
          Map<String, dynamic> individualhabitmapdata = json.decode(mapdata);
          List<String> keys = individualhabitmapdata.keys.toList();
          if (keys.isNotEmpty) {
            String lastKey = keys.removeLast();
            if (individualhabitmapdata[lastKey] != null) {
              if (individualhabitmapdata[lastKey] is bool) {
                individualhabitmapdata[key] = false;
              } else {
                individualhabitmapdata[key] = 0;
              }
            }
            keys.insert(0, key);
            Map updatedMap = {
              for (var key1 in keys) key1: mapdata[key1]!,
            };
            Functions().savetags(updatedMap, individualhabit);
          }
        }
      }
      Functions().savedata(listOfTags, 'myStringList');
    }
  }
}

class Functions {
  Future<void> gettags() async {
    String? serializedData = await HomeWidget.getWidgetData<String>('mapKey');

    if (serializedData != null) {
      retrievedMap = {};
      retrievedMap = json.decode(serializedData);
      pickLanguage.clear();
      pickLanguage = retrievedMap.keys.toList();
      if (pickLanguage.isEmpty) {
        pickLanguage.add('all');
      } else {
        pickLanguage.insert(0, 'all');
      }
    } else {
      if (pickLanguage.isEmpty) {
        pickLanguage.add('all');
      }
    }
  }

  Future<void> savetags(Map tosave, String name) async {
    String serializedMap = json.encode(tosave);
    await HomeWidget.saveWidgetData(name, serializedMap);
  }

  Future<void> savedata(List<String> lis, String name) async {
    String formattedString = lis.join('|');
    await HomeWidget.saveWidgetData(name, formattedString);
  }

  void initializationofhabit(String name, String type) {
    Map harry = {};
    DateTime today = DateTime.now();
    for (int i = 0; i <= 29; i++) {
      DateTime pastDate = today.subtract(Duration(days: i));
      String key = getFormattedDate(pastDate);
      if (type == 'yesOrNo') {
        harry[key] = false;
      } else if (type == 'measurable') {
        harry[key] = 0;
      }
    }
    Functions().savetags(harry, name);
  }

  String getFormattedDate(DateTime date) {
    return '${date.day}/${date.month}\n${DateFormat('E').format(date)}';
  }
}
