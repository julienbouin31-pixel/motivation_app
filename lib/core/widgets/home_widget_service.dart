import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  static const _appGroupId = 'group.com.JulienBouin.motivationApp';

  static Future<void> init() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  static Future<void> updateAffirmation({
    required String text,
    required String category,
  }) async {
    await HomeWidget.saveWidgetData<String>('affirmation_text', text);
    await HomeWidget.saveWidgetData<String>('affirmation_category', category);
    await _reloadAll();
  }

  static Future<void> _reloadAll() async {
    await HomeWidget.updateWidget(iOSName: 'AffirmationWidget');
    await HomeWidget.updateWidget(iOSName: 'LockScreenWidget');
  }
}
