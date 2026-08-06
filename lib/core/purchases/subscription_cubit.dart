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

  Future<PurchaseOutcome> purchase(Package package) async {
    final outcome = await PurchasesService.purchase(package);
    if (outcome == PurchaseOutcome.success && !isClosed) emit(true);
    return outcome;
  }

  Future<bool> restore() async {
    final ok = await PurchasesService.restore();
    if (!isClosed) emit(ok);
    return ok;
  }
}
