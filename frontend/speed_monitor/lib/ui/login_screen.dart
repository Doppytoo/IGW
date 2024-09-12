import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_monitor/models/user.dart';
import 'package:speed_monitor/providers/api.dart';
import 'package:speed_monitor/providers/secure_storage.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  Future<void> _onLoginPressed() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }

    try {
      final token = await ref.read(apiProvider).login(LoginDetails(
            username: _usernameController.text,
            password: _passwordController.text,
          ));

      ref.read(secureStorageProvider).requireValue.set('token', token);

      ref.read(secureStorageProvider).requireValue
        ..set('username', _usernameController.text)
        ..set('password', _passwordController.text);

      ref.invalidate(authTokenProvider);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse &&
          e.response!.statusCode == 400) {
        _usernameController.clear();
        _passwordController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Неверное имя пользователя или пароль'),
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.down,
          ));
        }
      } else {
        rethrow;
      }
    }
  }

  bool _isPasswordVisible = false;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        // actions: [
        //   IconButton(
        //     onPressed: onSettingsPressed,
        //     icon: const Icon(Icons.settings),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () => setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  }),
                ),
              ),
              obscureText: !_isPasswordVisible,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _onLoginPressed,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
