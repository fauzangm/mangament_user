import 'package:get_it/get_it.dart';
import 'package:mangament_acara/presentation/bloc/undangan/undangan_bloc.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/logto_service.dart';
import '../services/local_auth_service.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Services
  getIt.registerLazySingleton<LogtoService>(
    () => LogtoService(),
  );

  getIt.registerLazySingleton<LocalAuthService>(
    () => LocalAuthService(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<LogtoService>(),
      getIt<LocalAuthService>(),
    ),
  );

  // BLoC
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      authRepository: getIt<AuthRepository>(),
    ),
  );

    getIt.registerFactory<UndanganBloc>(
    () => UndanganBloc(),
  );
}
