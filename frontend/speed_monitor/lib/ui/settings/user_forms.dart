import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:speed_monitor/models/user.dart';
import 'package:speed_monitor/providers/data.dart';
import 'package:speed_monitor/ui/extras/async_value_wrapper.dart';

class EditUserForm extends ConsumerStatefulWidget {
  const EditUserForm({required this.userId, super.key});

  final int userId;

  @override
  ConsumerState<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends ConsumerState<EditUserForm> {
  final _usernameFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  bool? _isAdmin;

  bool _isPasswordVisible = false;

  bool _validateInput() {
    return (RegExp(r'\w{3,20}').stringMatch(_usernameFieldController.text) ==
            _usernameFieldController.text) &&
        (RegExp(r'(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[?!@$%^&*#-])[A-Za-z0-9?!@$%^&*#-]{8,}')
                    .stringMatch(_passwordFieldController.text) ==
                _passwordFieldController.text ||
            _passwordFieldController.text.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);

    return LayoutBuilder(
      builder: (context, constraints) => AsyncValueConnectionWrapper(
        value: usersAsync,
        onData: (users) {
          final user = users.firstWhere((usr) => usr.id == widget.userId);

          if (_usernameFieldController.text.isEmpty) {
            _usernameFieldController.text = user.username;
          }
          _isAdmin ??= user.isAdmin;

          return Container(
            width: min(constraints.maxWidth, 480),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Изменить сервис',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'\w{0,20}'))
                  ],
                  decoration:
                      const InputDecoration(label: Text('Имя пользователя')),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[A-Za-z0-9?!@$%^&*#-]'))
                  ],
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    label: const Text('Пароль'),
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
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Администратор?',
                        style: Theme.of(context).textTheme.bodyLarge),
                    Switch.adaptive(
                        value: _isAdmin!,
                        onChanged: (value) => setState(() {
                              _isAdmin = value;
                            }))
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Отмена'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () async {
                        if (!_validateInput()) return;

                        ref.read(usersProvider.notifier).updateUser(
                              user: User(
                                id: users.length,
                                username: _usernameFieldController.text,
                                isAdmin: _isAdmin!,
                              ),
                              password: _passwordFieldController.text.isNotEmpty
                                  ? _passwordFieldController.text
                                  : null,
                            );

                        if (mounted) Navigator.of(context).pop();
                      },
                      child: const Text('Применить'),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class NewUserForm extends ConsumerStatefulWidget {
  const NewUserForm({super.key});

  @override
  ConsumerState<NewUserForm> createState() => _NewUserFormState();
}

class _NewUserFormState extends ConsumerState<NewUserForm> {
  final _usernameFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  bool _isAdmin = false;

  bool _isPasswordVisible = false;

  bool _validateInput() {
    return (RegExp(r'\w{3,20}').stringMatch(_usernameFieldController.text) ==
            _usernameFieldController.text) &&
        (RegExp(r'(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[?!@$%^&*#-])[A-Za-z0-9?!@$%^&*#-]{8,}')
                .stringMatch(_passwordFieldController.text) ==
            _passwordFieldController.text);
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);

    return LayoutBuilder(
      builder: (context, constraints) => AsyncValueConnectionWrapper(
        value: usersAsync,
        onData: (users) {
          return Container(
            width: min(constraints.maxWidth, 480),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Изменить сервис',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'\w{0,20}'))
                  ],
                  decoration:
                      const InputDecoration(label: Text('Имя пользователя')),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[A-Za-z0-9?!@$%^&*#-]'))
                  ],
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    label: const Text('Пароль'),
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
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Администратор?',
                        style: Theme.of(context).textTheme.bodyLarge),
                    Switch.adaptive(
                        value: _isAdmin,
                        onChanged: (value) => setState(() {
                              _isAdmin = value;
                            }))
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Отмена'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () async {
                        if (!_validateInput()) return;

                        ref.read(usersProvider.notifier).createUser(
                              user: User(
                                id: users.length,
                                username: _usernameFieldController.text,
                                isAdmin: _isAdmin,
                              ),
                              password: _passwordFieldController.text,
                            );

                        if (mounted) Navigator.of(context).pop();
                      },
                      child: const Text('Применить'),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
