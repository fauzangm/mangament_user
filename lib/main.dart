import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mangament_acara/core/di/injection_container.dart' as di;
import 'package:mangament_acara/presentation/bloc/auth/auth_bloc.dart';
import 'package:mangament_acara/presentation/pages/beranda_page.dart';
import 'package:mangament_acara/presentation/pages/login_page.dart';
import 'package:mangament_acara/presentation/pages/presensi_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const PresensiPage(),
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.getIt<AuthBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'App',
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}