import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_master/core/constants/app_theme.dart';
import 'package:task_master/core/services/supabase_service.dart';
import 'package:task_master/features/auth/providers/auth_provider.dart';
import 'package:task_master/features/auth/screens/auth_screen.dart';
import 'package:task_master/features/tasks/providers/task_provider.dart';
import 'package:task_master/features/tasks/screens/tasks_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hozlbckkkzkaaimyijfx.supabase.co',
    anonKey: 'sb_publishable_ROAtF6MFCEIN24oPyFhNow_o1qwQd8S',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupabaseService>(
          create: (_) => SupabaseService(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            context.read<SupabaseService>(),
          ),
        ),
        ChangeNotifierProvider<TaskProvider>(
          create: (context) {
            final taskProvider = TaskProvider(
              context.read<SupabaseService>(),
            );
            context.read<AuthProvider>().addListener(() {
              taskProvider.handleAuthChanged(
                context.read<AuthProvider>().currentUser,
              );
            });
            return taskProvider;
          },
        ),
      ],
      child: const _AppContent(),
    );
  }
}

class _AppContent extends StatelessWidget {
  const _AppContent();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Master',
      theme: AppTheme.build(),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isAuthenticated) {
            return const TasksScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
