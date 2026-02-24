import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/models/affirmation_model.dart';

/// Peuple la DB au premier lancement depuis le JSON local.
/// Appelé dans main.dart avant runApp() — complètement hors ligne.
Future<void> seedAffirmationsIfEmpty(
  AffirmationLocalDataSource local, {
  String? name,
  String? mrrTarget,
}) async {
  final total = await local.totalCount();
  if (total > 0) return;

  final prenom = name ?? 'toi';
  final target = mrrTarget ?? '10K€';

  final jsonStr = await rootBundle.loadString('assets/data/affirmations.json');
  final List<dynamic> raw = json.decode(jsonStr) as List<dynamic>;

  final affirmations = raw.map((e) {
    final map = e as Map<String, dynamic>;
    final text = (map['text'] as String)
        .replaceAll('{name}', prenom)
        .replaceAll('{target}', target);
    return AffirmationModel.fromMap({'text': text, 'category': map['category']});
  }).toList();

  await local.saveAll(affirmations);
}
