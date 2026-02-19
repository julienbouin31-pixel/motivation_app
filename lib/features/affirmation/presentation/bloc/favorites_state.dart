import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';

abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<Affirmation> favorites;
  const FavoritesLoaded(this.favorites);
}

class FavoritesError extends FavoritesState {
  const FavoritesError();
}
