import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mangament_acara/core/di/injection_container.dart' as di;
import 'package:mangament_acara/presentation/bloc/undangan/undangan_bloc.dart';
import 'package:mangament_acara/presentation/pages/beranda_page.dart';
import 'package:mangament_acara/presentation/pages/login_page.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => BlocProvider(
        create: (_) => di.getIt<UndanganBloc>()..add(LoadUndangan()),
        child: const DashboardPage(),
      ),
    )
  ],
);
