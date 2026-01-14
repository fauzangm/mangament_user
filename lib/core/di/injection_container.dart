import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mangament_acara/presentation/bloc/undangan/undangan_bloc.dart';
import 'package:mangament_acara/presentation/bloc/undangan_detail/undangan_detail_bloc.dart';
import '../../data/repositories/undangan_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/undangan_repository.dart';
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

  getIt.registerLazySingleton<http.Client>(
    () => http.Client(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<LogtoService>(),
      getIt<LocalAuthService>(),
      getIt<http.Client>(),
    ),
  );

  getIt.registerLazySingleton<UndanganRepository>(
    () => UndanganRepositoryImpl(
      getIt<http.Client>(),
    ),
  );

  // BLoC
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<UndanganBloc>(
    () => UndanganBloc(
      undanganRepository: getIt<UndanganRepository>(),
    ),
  );

  getIt.registerFactory<UndanganDetailBloc>(
    () => UndanganDetailBloc(
      undanganRepository: getIt<UndanganRepository>(),
    ),
  );
}
