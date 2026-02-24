import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/models/affirmation_model.dart';

/// Peuple la DB au premier lancement depuis le JSON local.
/// Appelé dans main.dart avant runApp() — complètement hors ligne.
/// Les placeholders {name} et {target} sont conservés en DB,
/// le remplacement se fait à l'affichage dans AffirmationCard.
Future<void> seedAffirmationsIfEmpty(AffirmationLocalDataSource local) async {
  final total = await local.totalCount();
  if (total > 0) return;

  final jsonStr = await rootBundle.loadString('assets/data/affirmations.json');
  final List<dynamic> raw = json.decode(jsonStr) as List<dynamic>;

  final affirmations = raw.map((e) {
    final map = e as Map<String, dynamic>;
    return AffirmationModel.fromMap({
      'text': map['text'] as String,
      'category': map['category'],
    });
  }).toList();

  await local.saveAll(affirmations);
}
