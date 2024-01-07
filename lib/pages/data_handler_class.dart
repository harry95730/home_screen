import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class Counter extends ChangeNotifier {
  List<String> itemsInsideTagTemperory = [];
  List<String> allItemsInsideTag = [];
  int selectedTag = 0;
  List<ScrollController> controllers = [];

  void loadstate() async {
    var data = await HomeWidget.getWidgetData('myStringList');
    if (data != null) {
      if (data.isNotEmpty) {
        var list = data.split('|');
        allItemsInsideTag = list;
        for (var tempTagItem in allItemsInsideTag) {
          itemsInsideTagTemperory.add(tempTagItem);
          controllers.add(ScrollController());
        }
        controllers.add(ScrollController());
        managingControllers();
      }
    }
    notifyListeners();
  }

  void managingControllers() {
    for (ScrollController x in controllers) {
      x.addListener(() {
        final double currentOffset = x.position.pixels;
        for (ScrollController y in controllers) {
          if (y != x) {
            if ((currentOffset - y.position.pixels).abs() >= 0.01) {
              y.jumpTo(currentOffset);
            }
          }
        }
      });
    }
  }
}
