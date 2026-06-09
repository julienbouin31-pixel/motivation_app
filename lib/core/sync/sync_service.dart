import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:motivation_app/core/supabase/supabase_bootstrap.dart';
import 'package:motivation_app/core/sync/remote_sync_handler.dart';
import 'package:motivation_app/core/sync/sync_queue_dao.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SyncService {
  final SyncQueueDao _dao;
  final Connectivity _connectivity;
  final Map<String, RemoteSyncHandler> _handlers;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  StreamSubscription<AuthState>? _authSub;
  Timer? _periodicTimer;
  bool _draining = false;

  SyncService({
    required SyncQueueDao dao,
    required Connectivity connectivity,
    required List<RemoteSyncHandler> handlers,
  })  : _dao = dao,
        _connectivity = connectivity,
        _handlers = {for (final h in handlers) h.entityType: h};

  Future<void> start() async {
    _connectivitySub = _connectivity.onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        kick();
      }
    });

    _authSub = supabaseClient.auth.onAuthStateChange.listen((state) {
      if (state.session != null) kick();
    });

    _periodicTimer = Timer.periodic(const Duration(seconds: 60), (_) => kick());

    await kick();
  }

  Future<void> kick() async {
    if (_draining) return;
    if (supabaseClient.auth.currentSession == null) return;

    _draining = true;
    try {
      while (true) {
        final items = await _dao.pending(limit: 20);
        if (items.isEmpty) break;
        var anySucceeded = false;
        for (final item in items) {
          final handler = _handlers[item.entityType];
          if (handler == null) {
            await _dao.markFailed(item.id, 'no handler for ${item.entityType}');
            continue;
          }
          try {
            await handler.apply(item);
            await _dao.markDone(item.id);
            anySucceeded = true;
          } catch (e) {
            await _dao.markFailed(item.id, e.toString());
          }
        }
        if (!anySucceeded) break;
      }
    } finally {
      _draining = false;
    }
  }

  Future<void> dispose() async {
    await _connectivitySub?.cancel();
    await _authSub?.cancel();
    _periodicTimer?.cancel();
  }
}
