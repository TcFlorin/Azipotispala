import 'package:home_widget/home_widget.dart';
import 'main.dart';

void initWidgetListener() {
  HomeWidget.widgetClicked.listen((uri) async {
    print("Widget clicked! URI: $uri"); // debug
    if (uri == null) return;

    final today = await isHolidayToday();
    String text = today['isHoliday'] ? "Nu poți spăla ❌" : "Poți spăla ✅";
    String iconName = today['isHoliday'] ? "washred.png" : "washgreen.png";

    await HomeWidget.saveWidgetData<String>('widget_text', text);
    await HomeWidget.saveWidgetData<String>('widget_icon', iconName);
    await HomeWidget.updateWidget(name: 'WasherWidgetProvider');
  });
}
