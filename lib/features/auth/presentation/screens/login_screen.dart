import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/core/di/injection.dart';
import 'package:flutter_starter_kit/core/presentation/router/app_router.dart';
import 'package:flutter_starter_kit/core/presentation/widgets/app_loading.dart';
import 'package:flutter_starter_kit/core/presentation/widgets/app_snack_bar.dart';
import 'package:flutter_starter_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_starter_kit/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_starter_kit/features/auth/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == AuthStatus.failure) {
                AppSnackBar.showError(context, state.message);
              }
              if (state.status == AuthStatus.authenticated) {
                context.go(AppRouter.productPath);
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isSubmitting = state.status == AuthStatus.submitting;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 32,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 420,
                            child: Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Sign in to continue.',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Demo credentials: emilys / emilyspass',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: isSubmitting
                                            ? null
                                            : () {
                                                _usernameController.text =
                                                    'emilys';
                                                _passwordController.text =
                                                    'emilyspass';
                                              },
                                        child: const Text('Use demo'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  TextFormField(
                                    controller: _usernameController,
                                    enabled: !isSubmitting,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      labelText: 'Username',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      final trimmed = value?.trim() ?? '';
                                      if (trimmed.isEmpty) {
                                        return 'Username is required';
                                      }
                                      if (trimmed.length < 3) {
                                        return 'Username should be at least 3 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _passwordController,
                                    enabled: !isSubmitting,
                                    obscureText: !_isPasswordVisible,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) =>
                                        _submit(context, isSubmitting),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      final trimmed = value?.trim() ?? '';
                                      if (trimmed.isEmpty) {
                                        return 'Password is required';
                                      }
                                      if (trimmed.length < 6) {
                                        return 'Password should be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 48,
                                    child: FilledButton(
                                      onPressed: isSubmitting
                                          ? null
                                          : () =>
                                                _submit(context, isSubmitting),
                                      child: isSubmitting
                                          ? const AppLoading(
                                              size: 20,
                                              strokeWidth: 2,
                                            )
                                          : const Text('Sign In'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context, bool isSubmitting) {
    if (isSubmitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthBloc>().add(
      LoginSubmitted(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }
}
