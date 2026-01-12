import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mangament_acara/core/themes/AppColors.dart';
import '../bloc/auth/auth_bloc.dart';
import '../widgets/neumorphic_button.dart';
import '../widgets/neumorphic_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isSignUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  void _authenticate() {
    if (_isSignUp) {
      context.read<AuthBloc>().add(
            SignUpRequested(
              username: _usernameController.text,
              password: _passwordController.text,
              email: _emailController.text,
            ),
          );
    } else {
      context.read<AuthBloc>().add(
            LoginRequested(
              username: _usernameController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
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
                  SnackBar(content: Text('Welcome ${state.user.username}!'), backgroundColor: AppColors.primary),
                );
                context.go('/dashboard');
              }
            },
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        gradient: AppColors.cardGradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(color: AppColors.shadowDark, offset: const Offset(8, 8), blurRadius: 24),
                          BoxShadow(color: AppColors.shadowLight, offset: const Offset(-8, -8), blurRadius: 24),
                        ],
                      ),
                      child: const Icon(Icons.event, size: 56, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 40),
                    
                    // Title
                    Text(
                      _isSignUp ? 'Create Account' : 'Welcome Back',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Subtitle
                    Text(
                      _isSignUp
                          ? 'Sign up to get started'
                          : 'Sign in to continue',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF718096),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Email field (only for sign up)
                    if (_isSignUp) ...[
                      NeumorphicTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                    ],
                    
                    // Username field
                    NeumorphicTextField(
                      controller: _usernameController,
                      hintText: 'Username',
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    
                    // Password field
                    NeumorphicTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    
                    // Auth Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return NeumorphicButton(
                          height: 55,
                          onPressed: state is AuthLoading ? null : _authenticate,
                          backgroundColor: state is AuthLoading
                              ? const Color(0xFFCBD5E0)
                              : const Color(0xFF4299E1),
                          child: state is AuthLoading
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF2D3748),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Loading...',
                                      style: TextStyle(
                                        color: Color(0xFF2D3748),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  _isSignUp ? 'Sign Up' : 'Sign In',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.textSecondary.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.textSecondary.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Logto Login Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: state is AuthLoading
                              ? null
                              : () {
                                  context.read<AuthBloc>().add(
                                        const LoginWithLogtoRequested(),
                                      );
                                },
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              gradient: AppColors.cardGradient,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowDark,
                                  offset: const Offset(4, 4),
                                  blurRadius: 12,
                                ),
                                BoxShadow(
                                  color: AppColors.shadowLight,
                                  offset: const Offset(-4, -4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/logto_icon.png', // You'll need to add this asset
                                  width: 24,
                                  height: 24,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.login,
                                      size: 24,
                                      color: AppColors.primary,
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Sign in with Logto',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Toggle Button
                    if (!_isSignUp)
                      NeumorphicButton(
                        height: 45,
                        backgroundColor: const Color(0xFFE0E5EC),
                        onPressed: _toggleMode,
                        child: const Text(
                          'Don\'t have an account? Sign Up',
                          style: TextStyle(
                            color: Color(0xFF4A5568),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
