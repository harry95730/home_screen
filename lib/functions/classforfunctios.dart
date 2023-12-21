import 'dart:convert';
import 'package:home_widget/home_widget.dart';

Map<String, dynamic> retrievedMap = {};
List<String> pickLanguage = <String>[];

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

  Future<void> savetags() async {
    String serializedMap = json.encode(retrievedMap);
    await HomeWidget.saveWidgetData('mapKey', serializedMap);
  }

  Future<void> savedata(List<String> lis, String name) async {
    String formattedString = lis.join('|');
    await HomeWidget.saveWidgetData(name, formattedString);
  }
}
