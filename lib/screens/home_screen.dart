import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();
            },
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Text(
                            user?.email.substring(0, 1).toUpperCase() ?? '?',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.email ?? 'Неизвестно',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.isEmailVerified == true
                                    ? '✓ Email подтвержден'
                                    : '⚠️ Email не подтвержден',
                                style: TextStyle(
                                  color: user?.isEmailVerified == true
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '📢 Публичный контент',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.public),
                          title: Text('Новости приложения'),
                          subtitle: Text('Доступно всем пользователям'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.help),
                          title: Text('Часто задаваемые вопросы'),
                          subtitle: Text('Доступно всем пользователям'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '⭐ Эксклюзивный контент',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (authProvider.isAuthenticated)
                  Card(
                    color: Colors.purple.shade50,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.star, color: Colors.amber),
                            title: Text('Специальные предложения'),
                            subtitle: Text('Только для авторизованных'),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.favorite, color: Colors.red),
                            title: Text('Избранное'),
                            subtitle: Text('Сохраняйте понравившийся контент'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Card(
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.lock, size: 48, color: Colors.grey),
                          const SizedBox(height: 8),
                          const Text('🔒 Эксклюзивный контент'),
                          const Text(
                            'Войдите в аккаунт, чтобы получить доступ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/auth');
                            },
                            child: const Text('Войти'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}