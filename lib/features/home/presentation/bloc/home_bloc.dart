import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/core/usecases/usecase.dart';
import 'package:motivation_app/features/home/domain/entities/home_entity.dart';
import 'package:motivation_app/features/home/domain/usecases/get_home_data.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeData getHomeData;

  HomeBloc({required this.getHomeData}) : super(HomeInitial()) {
    on<GetHomeDataEvent>(_onGetHomeData);
  }

  Future<void> _onGetHomeData(
    GetHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    final result = await getHomeData(NoParams());
    result.fold(
      (failure) => emit(const HomeError('An error occurred')),
      (data) => emit(HomeLoaded(data)),
    );
  }
}
