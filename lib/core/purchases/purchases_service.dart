import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Wrapper autour du SDK RevenueCat.
///
/// Dégradation gracieuse : si `REVENUECAT_API_KEY_IOS` n'est pas dans le .env,
/// le SDK n'est pas configuré et l'app tourne en mode 100% gratuit (isPremium
/// renvoie toujours false, le paywall affiche un état vide).
class PurchasesService {
  PurchasesService._();

  /// Identifiant de l'entitlement "premium" à créer dans le dashboard
  /// RevenueCat (Project → Entitlements). Toutes les offres (mensuel, annuel)
  /// doivent débloquer cet entitlement.
  static const String entitlementId = 'premium';

  static bool _configured = false;
  static bool get isConfigured => _configured;

  // ─── Init ─────────────────────────────────────────────────────────────────

  static Future<void> init() async {
    final apiKey = dotenv.env['REVENUECAT_API_KEY_IOS'];
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('[Purchases] REVENUECAT_API_KEY_IOS absent → mode gratuit.');
      return;
    }
    try {
      await Purchases.setLogLevel(LogLevel.warn);
      await Purchases.configure(PurchasesConfiguration(apiKey));
      _configured = true;
      debugPrint('[Purchases] Configuré.');
    } catch (e) {
      debugPrint('[Purchases] Échec de configuration: $e');
    }
  }

  // ─── Statut premium ─────────────────────────────────────────────────────────

  static Future<bool> isPremium() async {
    if (!_configured) return false;
    try {
      final info = await Purchases.getCustomerInfo();
      return _hasPremium(info);
    } catch (e) {
      debugPrint('[Purchases] isPremium error: $e');
      return false;
    }
  }

  static bool _hasPremium(CustomerInfo info) =>
      info.entitlements.active.containsKey(entitlementId);

  /// Notifié à chaque changement d'abonnement (achat, expiration, restauration).
  static void addPremiumListener(void Function(bool isPremium) onChange) {
    if (!_configured) return;
    Purchases.addCustomerInfoUpdateListener(
      (info) => onChange(_hasPremium(info)),
    );
  }

  // ─── Offres ───────────────────────────────────────────────────────────────

  /// Offre courante (mensuel / annuel…) configurée dans RevenueCat.
  static Future<Offering?> currentOffering() async {
    if (!_configured) return null;
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current;
    } catch (e) {
      debugPrint('[Purchases] getOfferings error: $e');
      return null;
    }
  }

  // ─── Achat / restauration ────────────────────────────────────────────────

  /// Retourne true si l'utilisateur est premium après l'achat.
  static Future<bool> purchase(Package package) async {
    if (!_configured) return false;
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      final premium = _hasPremium(result.customerInfo);
      if (!premium) {
        debugPrint(
          '[Purchases] Achat OK mais entitlement "$entitlementId" inactif — '
          'vérifie que l\'entitlement existe sous ce nom et que le produit y '
          'est attaché. Entitlements actifs: '
          '${result.customerInfo.entitlements.active.keys.toList()}',
        );
      }
      return premium;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code != PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('[Purchases] purchase error: $e');
      }
      return false;
    } catch (e) {
      debugPrint('[Purchases] purchase error: $e');
      return false;
    }
  }

  /// Restaure les achats précédents. Retourne true si premium après restauration.
  static Future<bool> restore() async {
    if (!_configured) return false;
    try {
      final info = await Purchases.restorePurchases();
      return _hasPremium(info);
    } catch (e) {
      debugPrint('[Purchases] restore error: $e');
      return false;
    }
  }
}
