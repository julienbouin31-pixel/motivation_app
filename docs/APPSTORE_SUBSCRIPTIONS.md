# Créer les abonnements dans App Store Connect

Objectif : deux abonnements auto-renouvelables (mensuel 2,99 € / annuel ~20 €)
avec 3 jours d'essai gratuit, reliés ensuite à RevenueCat.

## Prérequis (sinon les produits ne remontent jamais)

1. **Apple Developer Program** actif (99 €/an).
2. **L'app existe** dans App Store Connect (fiche créée, bundle id
   `com.JulienBouin.motivationApp`).
3. **Accords Paid Apps signés** : App Store Connect → *Business* (Agreements,
   Tax, and Banking) → le contrat « Paid Applications » doit être **Active**,
   avec les infos bancaires + fiscales remplies. ⚠️ C'est l'oubli n°1.

## Étape 1 — Groupe d'abonnements

App Store Connect → ton app → onglet **Monetization → Subscriptions** →
**Create Subscription Group**.
- Nom de référence : `Curves Premium` (interne, invisible des users).
- Un groupe = des offres mutuellement exclusives (mensuel/annuel ensemble :
  l'utilisateur ne peut en avoir qu'une à la fois — c'est ce qu'on veut).

## Étape 2 — Les deux abonnements

Dans le groupe, **Create Subscription** deux fois.

**Mensuel :**
- Reference Name : `Curves Premium Mensuel`
- **Product ID : `curves_premium_monthly`** ⚠️ définitif, non modifiable
- Duration : 1 Month
- Prix : **2,99 €** (choisir le price point le plus proche)

**Annuel :**
- Reference Name : `Curves Premium Annuel`
- **Product ID : `curves_premium_yearly`**
- Duration : 1 Year
- Prix : **19,99 €** (palier standard le plus proche de 20 €)

## Étape 3 — Essai gratuit de 3 jours

Sur **chaque** abonnement → section **Introductory Offers** → **Create Offer** :
- Type : **Free** (gratuit)
- Duration : **3 days**
- Territoires : tous
(Si tu ne veux l'essai que sur l'annuel, ne le mets que là — mais le paywall
de l'app parle d'essai, donc le mettre sur les deux est plus cohérent.)

## Étape 4 — Infos obligatoires pour la review

Pour chaque abonnement :
- **Localizations** : nom d'affichage (ex. « Curves Premium – Mensuel ») +
  description.
- **Review screenshot** : une capture du paywall (obligatoire au moins pour
  le premier abonnement soumis).
- Vérifier les prix par territoire.

L'état de chaque abonnement passera à « Ready to Submit » quand tout est rempli.
Ils seront soumis avec la prochaine version de l'app (ou peuvent être testés en
sandbox avant, voir RevenueCat).

## Étape 5 — Relier à RevenueCat

Voir `REVENUECAT_SETUP.md`. En résumé :
1. RevenueCat → **Apps** → ajouter une app **App Store** (bundle id
   `com.JulienBouin.motivationApp`) + la clé « In-App Purchase » d'App Store
   Connect → ça génère la clé publique **`appl_…`**.
2. **Products** → importer `curves_premium_monthly` et `curves_premium_yearly`.
3. **Entitlements** → `Curves Pro` → attacher les deux produits.
4. **Offerings** → offering « Current » → package **Monthly** + package **Annual**.
5. Mettre la clé `appl_…` dans `.env` (`REVENUECAT_API_KEY_IOS`) et rebuild.

## Étape 6 — Tester en sandbox (vrai iPhone)

- App Store Connect → *Users and Access → Sandbox → Testers* → créer un compte.
- Sur l'iPhone : Réglages → App Store → connecte-toi avec le compte sandbox.
- Lance l'app en release sur l'appareil, ouvre le paywall, achète : le flux
  Apple s'affiche en mode sandbox (pas de vrai débit), et l'entitlement
  `Curves Pro` doit se débloquer.
