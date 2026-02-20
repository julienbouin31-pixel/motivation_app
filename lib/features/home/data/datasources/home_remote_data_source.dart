import 'package:injectable/injectable.dart';
import 'package:motivation_app/features/home/data/models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeModel>> getHomeData();
}

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  // TODO: Inject your HTTP client (dio, http, etc.)

  HomeRemoteDataSourceImpl();

  @override
  Future<List<HomeModel>> getHomeData() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
