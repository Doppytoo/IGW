import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_monitor/providers/data.dart';
import 'package:speed_monitor/ui/extras/async_value_wrapper.dart';
import 'package:speed_monitor/ui/settings/user_forms.dart';

class UsersSettingsScreen extends ConsumerWidget {
  const UsersSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Пользователи'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => const Dialog(child: NewUserForm()),
        ),
        child: const Icon(Icons.add),
      ),
      body: AsyncValueConnectionWrapper(
        value: usersAsync,
        onData: (users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (ctx, idx) => ListTile(
              title: Text(users[idx].username),
              subtitle:
                  Text(users[idx].isAdmin ? 'Администратор' : 'Пользователь'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (ctx) =>
                            Dialog(child: EditUserForm(userId: users[idx].id))),
                    icon: const Icon(Icons.edit),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text('Удалить пользователя?'),
                                content: const Text(
                                    'Пользователь будет удалён навсегда.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('Нет'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await ref
                                          .read(usersProvider.notifier)
                                          .deleteUser(users[idx].id);

                                      if (ctx.mounted) Navigator.of(ctx).pop();
                                    },
                                    child: const Text('Да'),
                                  ),
                                ],
                              ));
                    },
                    icon: const Icon(Icons.delete),
                    color: Theme.of(ctx).colorScheme.error,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
