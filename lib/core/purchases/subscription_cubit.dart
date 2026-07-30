import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:motivation_app/core/purchases/purchases_service.dart';

/// État d'abonnement exposé à toute l'app : `state == true` ⇔ premium actif.
class SubscriptionCubit extends Cubit<bool> {
  SubscriptionCubit() : super(false);

  Future<void> load() async {
    emit(await PurchasesService.isPremium());
    // Se met à jour tout seul sur achat / expiration / restauration.
    PurchasesService.addPremiumListener((premium) {
      if (!isClosed) emit(premium);
    });
  }

  Future<bool> purchase(Package package) async {
    final ok = await PurchasesService.purchase(package);
    if (ok && !isClosed) emit(true);
    return ok;
  }

  Future<bool> restore() async {
    final ok = await PurchasesService.restore();
    if (!isClosed) emit(ok);
    return ok;
  }
}
