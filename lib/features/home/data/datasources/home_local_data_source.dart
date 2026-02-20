import 'package:injectable/injectable.dart';
import 'package:motivation_app/features/home/data/models/home_model.dart';

abstract class HomeLocalDataSource {
  Future<List<HomeModel>> getLastHomeData();
  Future<void> cacheHomeData(List<HomeModel> data);
}

@LazySingleton(as: HomeLocalDataSource)
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  // TODO: Inject SharedPreferences or Hive

  HomeLocalDataSourceImpl();

  @override
  Future<List<HomeModel>> getLastHomeData() async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<void> cacheHomeData(List<HomeModel> data) async {
    // TODO: Implement cache storage
    throw UnimplementedError();
  }
}
