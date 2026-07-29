import 'dart:convert';

import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  static const _appGroupId = 'group.com.JulienBouin.motivationApp';

  static Future<void> init() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  /// Affirmation unique (fallback / rendu immédiat quand on ouvre l'app).
  static Future<void> updateAffirmation({
    required String text,
    required String category,
  }) async {
    await HomeWidget.saveWidgetData<String>('affirmation_text', text);
    await HomeWidget.saveWidgetData<String>('affirmation_category', category);
    await _reloadAll();
  }

  /// Réservoir d'affirmations dans lequel le widget pioche tout seul pour
  /// tourner plusieurs fois par jour, même app fermée. [items] = liste de
  /// {'text': ..., 'category': ...} déjà résolus (placeholders remplacés).
  static Future<void> updatePool(List<Map<String, String>> items) async {
    await HomeWidget.saveWidgetData<String>(
      'affirmation_pool',
      jsonEncode(items),
    );
    await _reloadAll();
  }

  static Future<void> _reloadAll() async {
    await HomeWidget.updateWidget(iOSName: 'AffirmationWidget');
    await HomeWidget.updateWidget(iOSName: 'LockScreenWidget');
  }

  /// URI (curves://affirmation?id=…) si l'app a été lancée à froid via un tap
  /// sur le widget.
  static Future<Uri?> initiallyLaunched() =>
      HomeWidget.initiallyLaunchedFromHomeWidget();

  /// Taps sur le widget pendant que l'app tourne déjà.
  static Stream<Uri?> get clicks => HomeWidget.widgetClicked;

  /// Extrait l'id d'affirmation d'une URI de tap widget.
  static int? affirmationIdFrom(Uri? uri) {
    if (uri == null) return null;
    return int.tryParse(uri.queryParameters['id'] ?? '');
  }
}
