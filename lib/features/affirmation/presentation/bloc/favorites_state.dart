import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';

part 'favorites_state.freezed.dart';

@freezed
sealed class FavoritesState with _$FavoritesState {
  const factory FavoritesState.initial() = FavoritesInitial;
  const factory FavoritesState.loading() = FavoritesLoading;
  const factory FavoritesState.loaded(List<Affirmation> favorites) = FavoritesLoaded;
  const factory FavoritesState.error() = FavoritesError;
}
