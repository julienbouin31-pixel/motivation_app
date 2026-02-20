import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/injection_container.config.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> init() async => sl.init();
