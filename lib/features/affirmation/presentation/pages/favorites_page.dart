import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
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
    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: AppStyle.ink.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('mes favoris', style: AppStyle.display(size: 30)),
                      const Spacer(),
                      BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, state) {
                          final count = state is FavoritesLoaded
                              ? state.favorites.length
                              : 0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('$count', style: AppStyle.overline),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ─── Recherche ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v.toLowerCase()),
                style: const TextStyle(fontSize: 15, color: AppStyle.ink),
                cursorColor: AppStyle.ink,
                decoration: InputDecoration(
                  hintText: 'rechercher…',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: AppStyle.dim,
                  ),
                  icon: Icon(
                    Icons.search,
                    size: 18,
                    color: AppStyle.ink.withValues(alpha: 0.4),
                  ),
                  suffixIcon: _query.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: AppStyle.ink.withValues(alpha: 0.4),
                          ),
                        )
                      : null,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppStyle.hairline),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppStyle.ink.withValues(alpha: 0.5),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),

            // ─── Contenu ─────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) => switch (state) {
                  FavoritesLoading() => const Center(
                      child: CircularProgressIndicator(color: AppStyle.dim),
                    ),
                  FavoritesError() => const Center(
                      child: Text(
                        'Erreur lors du chargement',
                        style: TextStyle(color: AppStyle.dim),
                      ),
                    ),
                  FavoritesLoaded(:final favorites) => favorites.isEmpty
                      ? const _EmptyState()
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
  const _EmptyState();

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
              shape: BoxShape.circle,
              border: Border.all(color: AppStyle.hairline),
            ),
            child: Icon(
              Icons.favorite_border,
              size: 26,
              color: AppStyle.ink.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'rien ici pour l\'instant.',
            style: AppStyle.display(size: 20),
          ),
          const SizedBox(height: 8),
          const Text(
            'Appuie sur le cœur pour garder une affirmation.',
            style: TextStyle(fontSize: 13, color: AppStyle.dim),
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
    final filtered = query.isEmpty
        ? favorites
        : favorites
            .where((a) =>
                a.text.toLowerCase().contains(query) ||
                a.category.label.toLowerCase().contains(query))
            .toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'Aucun résultat pour "$query"',
          style: const TextStyle(fontSize: 14, color: AppStyle.dim),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
      itemCount: filtered.length,
      itemBuilder: (context, i) => _FavoriteRow(affirmation: filtered[i]),
    );
  }
}

// ─── Rangée ───────────────────────────────────────────────────────────────────

class _FavoriteRow extends StatelessWidget {
  final Affirmation affirmation;
  const _FavoriteRow({required this.affirmation});

  @override
  Widget build(BuildContext context) {
    final onboardingState = context.watch<OnboardingCubit>().state;
    final profile = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };
    final displayText =
        affirmation.text.replaceAll('{name}', profile?.name ?? 'toi');

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppStyle.hairline)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayText,
                  style: AppStyle.display(size: 16).copyWith(height: 1.5),
                ),
                const SizedBox(height: 6),
                Text(
                  affirmation.category.label.toLowerCase(),
                  style: AppStyle.overline,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () =>
                context.read<FavoritesCubit>().removeFavorite(affirmation.id),
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(Icons.favorite, color: Colors.red.shade400, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
