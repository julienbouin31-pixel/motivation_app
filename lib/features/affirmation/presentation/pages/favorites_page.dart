import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/favorites_cubit.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/favorites_state.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/injection_container.dart' as di;

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<FavoritesCubit>()..load(),
      child: const _FavoritesView(),
    );
  }
}

class _FavoritesView extends StatefulWidget {
  const _FavoritesView();

  @override
  State<_FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<_FavoritesView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, size: 20, color: colors.primary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Mes favoris',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  const Spacer(),
                  // Compteur
                  BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      final count = state is FavoritesLoaded ? state.favorites.length : 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.secondary,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ─── Barre de recherche ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v.toLowerCase()),
                  style: TextStyle(fontSize: 14, color: colors.primary),
                  decoration: InputDecoration(
                    hintText: 'Rechercher...',
                    hintStyle: TextStyle(fontSize: 14, color: colors.secondary),
                    prefixIcon: Icon(Icons.search, size: 18, color: colors.secondary),
                    suffixIcon: _query.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            child: Icon(Icons.close, size: 16, color: colors.secondary),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // ─── Contenu ─────────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) => switch (state) {
                  FavoritesLoading() => Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    ),
                  FavoritesError() => Center(
                      child: Text(
                        'Erreur lors du chargement',
                        style: TextStyle(color: colors.secondary),
                      ),
                    ),
                  FavoritesLoaded(:final favorites) => favorites.isEmpty
                      ? _EmptyState(colors: colors)
                      : _FavoritesList(favorites: favorites, query: _query),
                  _ => const SizedBox.shrink(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final AppColors colors;
  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite_border, size: 28, color: colors.secondary),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun favori pour l\'instant',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Appuie sur ❤️ pour sauvegarder une affirmation',
            style: TextStyle(fontSize: 13, color: colors.secondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Liste ────────────────────────────────────────────────────────────────────

class _FavoritesList extends StatelessWidget {
  final List<Affirmation> favorites;
  final String query;
  const _FavoritesList({required this.favorites, required this.query});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final filtered = query.isEmpty
        ? favorites
        : favorites
            .where((a) => a.text.toLowerCase().contains(query) ||
                a.category.label.toLowerCase().contains(query))
            .toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'Aucun résultat pour "$query"',
          style: TextStyle(fontSize: 14, color: colors.secondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      itemCount: filtered.length,
      separatorBuilder: (context, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _FavoriteCard(affirmation: filtered[i]),
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _FavoriteCard extends StatelessWidget {
  final Affirmation affirmation;
  const _FavoriteCard({required this.affirmation});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final onboardingState = context.watch<OnboardingCubit>().state;
    final profile = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };
    final displayText = affirmation.text
        .replaceAll('{name}', profile?.name ?? 'toi');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"$displayText"',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '— ${affirmation.category.label}',
                  style: TextStyle(fontSize: 12, color: colors.secondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => context.read<FavoritesCubit>().removeFavorite(affirmation.id),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: Colors.red, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
