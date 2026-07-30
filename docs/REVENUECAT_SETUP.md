# Configuration RevenueCat (abonnements)

Le code est en place (branche `feat/revenuecat`). Tant que la clé API n'est pas
renseignée, l'app tourne en **mode gratuit** : le paywall affiche « abonnements
non configurés » et `isPremium` reste `false`. Voici les étapes pour l'activer.

## 1. App Store Connect — créer les produits

1. App Store Connect → ton app → **Abonnements** (In-App Purchases).
2. Crée un **groupe d'abonnements** (ex. « Curves Premium »).
3. Ajoute deux abonnements auto-renouvelables :
   - **Mensuel** — ex. `curves_premium_monthly`
   - **Annuel** — ex. `curves_premium_yearly`
4. Renseigne prix, description, et (recommandé) une **offre d'essai gratuit**.
5. Remplis les accords bancaires/fiscaux (Agreements, Tax, and Banking), sinon
   les produits ne remontent pas.

## 2. RevenueCat — projet + produits

1. Crée un compte sur https://app.revenuecat.com et un **projet**.
2. Ajoute une app **App Store**, avec le bundle id `com.JulienBouin.motivationApp`
   et la **clé API In-App Purchase** (App Store Connect → Users and Access → Integrations → In-App Purchase key).
3. **Products** → importe/ajoute `curves_premium_monthly` et `curves_premium_yearly`.
4. **Entitlements** → crée un entitlement d'identifiant **`premium`**
   (⚠️ doit correspondre à `PurchasesService.entitlementId`) et attache-lui les
   deux produits.
5. **Offerings** → crée une offering **Current** (« default ») avec deux
   packages : **Monthly** → produit mensuel, **Annual** → produit annuel.
   Le paywall lit `offerings.current` et affiche ces packages automatiquement.

## 3. Clé API dans l'app

1. RevenueCat → **API keys** → copie la clé **publique App Store** (préfixe `appl_`).
2. Dans ton `.env` local (non versionné) :
   ```
   REVENUECAT_API_KEY_IOS=appl_xxxxxxxxxxxxxxxx
   ```
3. Relance l'app (rebuild complet). Le paywall affichera alors tes vraies offres.

## 4. Tester les achats

- Les achats **ne fonctionnent pas sur simulateur** : teste sur un **vrai
  iPhone** avec un **compte Sandbox** (App Store Connect → Users and Access →
  Sandbox Testers).
- Sur l'appareil : Réglages iOS → App Store → connecte-toi avec le compte
  sandbox, puis lance un achat depuis le paywall.
- « Restaurer » et l'expiration se reflètent automatiquement (`isPremium` est
  réactif via `SubscriptionCubit`).

## 5. Ce qui reste côté produit

Le **gating** (quelles fonctionnalités sont réservées au premium) n'est pas
encore branché : pour l'instant seul le paywall et le statut `isPremium`
existent. Prochaine étape : décider ce qui est premium (catégories, thèmes,
affirmations perso illimitées…) et gater ces écrans sur `context.watch<SubscriptionCubit>().state`.
