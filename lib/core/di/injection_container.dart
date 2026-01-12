import 'package:get_it/get_it.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/logto_service.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Services
  getIt.registerLazySingleton<LogtoService>(
    () => LogtoService(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<LogtoService>()),
  );

  // BLoC
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      authRepository: getIt<AuthRepository>(),
    ),
  );
}
