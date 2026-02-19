import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/features/home/domain/usecases/get_home_data.dart';
import 'package:motivation_app/features/home/presentation/bloc/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase getHomeData;

  HomeCubit({required this.getHomeData}) : super(const HomeState.initial());

  Future<void> loadHomeData() async {
    emit(const HomeState.loading());
    final result = await getHomeData();
    result.fold(
      (failure) => emit(const HomeState.error('Une erreur est survenue')),
      (data) => emit(HomeState.loaded(data)),
    );
  }
}
