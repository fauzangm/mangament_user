import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mangament_acara/core/sessionMangaer.dart';
import 'package:mangament_acara/core/themes/AppColors.dart';
import '../bloc/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

@override
void initState() {
  super.initState();
  _checkLogin();
}

Future<void> _checkLogin() async {
  final isLogin = await getIsLogin();

  if (!mounted) return;

  if (isLogin == true) {
    context.go('/dashboard');
  }
}

  void _authenticate() {
    context.read<AuthBloc>().add(
          LoginRequested(
            username: _usernameController.text,
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.glossyGradient,
        ),
        child: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
                );
              } else if (state is AuthAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Welcome ${state.user.user?.name ?? ""}!'), backgroundColor: AppColors.primary),
                );
                SaveTokenToSessionManager(state.user.accessToken ?? "");
                context.go('/dashboard');
              }
            },
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Shield Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.security,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Title
                    const Text(
                      'Invitation Portal',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Subtitle
                    const Text(
                      'Secure access to official events',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 50),
                    
                    // Username field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your username',
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                          prefixIcon: Icon(Icons.person, color: Color(0xFF6B7280)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Password field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF6B7280)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: const Color(0xFF6B7280),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Login Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: state is AuthLoading ? null : _authenticate,
                              child: Center(
                                child: state is AuthLoading
                                    ? const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Loading...',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFFE5E7EB),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFFE5E7EB),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Sign in with Logto Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: state is AuthLoading
                                  ? null
                                  : () {
                                      context.read<AuthBloc>().add(
                                            const LoginWithLogtoRequested(),
                                          );
                                    },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.security,
                                    size: 24,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Sign in with Logto',
                                    style: TextStyle(
                                      color: Color(0xFF1F2937),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    
                    // Footer text
                    Column(
                      children: [
                        const Text(
                          'Secure government portal',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '© 2026 Official Invitation System',
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
