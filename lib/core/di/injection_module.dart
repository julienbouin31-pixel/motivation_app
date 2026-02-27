import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/database/app_database.dart';

@module
abstract class AppModule {
  @singleton
  Connectivity get connectivity => Connectivity();

  @preResolve
  @singleton
  Future<AppDatabase> get appDatabase => openAppDatabase();
}
