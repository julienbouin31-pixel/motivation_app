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

  static Future<void> updateGoal({
    required double current,
    required double target,
    required double changePct,
    required String objectiveType,
  }) async {
    await HomeWidget.saveWidgetData<double>('goal_current', current);
    await HomeWidget.saveWidgetData<double>('goal_target', target);
    await HomeWidget.saveWidgetData<double>('goal_change_pct', changePct);
    await HomeWidget.saveWidgetData<String>('objective_type', objectiveType);
    await _reloadAll();
  }

  static Future<void> _reloadAll() async {
    await HomeWidget.updateWidget(iOSName: 'AffirmationWidget');
    await HomeWidget.updateWidget(iOSName: 'MrrWidget');
    await HomeWidget.updateWidget(iOSName: 'CombinedWidget');
  }
}
