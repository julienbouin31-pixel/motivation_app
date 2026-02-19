import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motivation_app/features/home/domain/entities/home_entity.dart';

part 'home_state.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeInitial;
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded(List<HomeEntity> data) = HomeLoaded;
  const factory HomeState.error(String message) = HomeError;
}
