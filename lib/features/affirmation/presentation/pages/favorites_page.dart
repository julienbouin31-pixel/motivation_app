import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _FavoritesView extends StatelessWidget {
  const _FavoritesView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.card,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Mes favoris',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) => switch (state) {
          FavoritesLoading() => Center(
              child: CircularProgressIndicator(color: colors.primary),
            ),
          FavoritesError() => const Center(
              child: Text('Erreur lors du chargement'),
            ),
          FavoritesLoaded(:final favorites) => favorites.isEmpty
              ? _EmptyFavorites()
              : _FavoritesList(favorites: favorites),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: colors.border),
          const SizedBox(height: 16),
          Text(
            'Pas encore de favoris',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Like une affirmation pour la retrouver ici',
            style: TextStyle(fontSize: 14, color: colors.secondary),
          ),
        ],
      ),
    );
  }
}

class _FavoritesList extends StatelessWidget {
  final List<Affirmation> favorites;
  const _FavoritesList({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: favorites.length,
      separatorBuilder: (context, i) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final a = favorites[index];
        return _FavoriteCard(affirmation: a);
      },
    );
  }
}

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
        .replaceAll('{name}', profile?.name ?? 'toi')
        .replaceAll('{target}', profile?.mrrTarget ?? '10K€');

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      decoration: BoxDecoration(
        color: colors.scaffold,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    affirmation.category.label,
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.scaffold,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '"$displayText"',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () =>
                context.read<FavoritesCubit>().removeFavorite(affirmation.id),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.favorite, color: Colors.red, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
