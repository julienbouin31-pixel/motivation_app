import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/get_favorites_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/toggle_favorite_usecase.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase getFavorites;
  final ToggleFavoriteUseCase toggleFavorite;

  FavoritesCubit({
    required this.getFavorites,
    required this.toggleFavorite,
  }) : super(const FavoritesInitial());

  Future<void> load() async {
    emit(const FavoritesLoading());
    final result = await getFavorites();
    result.fold(
      (_) => emit(const FavoritesError()),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> removeFavorite(int id) async {
    await toggleFavorite(id);
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      emit(FavoritesLoaded(
        currentState.favorites.where((a) => a.id != id).toList(),
      ));
    }
  }
}
