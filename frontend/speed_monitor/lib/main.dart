import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/providers/preferences.dart';

import 'package:speed_monitor/ui/home/home_page.dart';
import 'package:speed_monitor/ui/incidents/incidents_page.dart';
import 'package:speed_monitor/ui/settings/settings_page.dart';
import 'package:speed_monitor/providers/api.dart';
import 'package:speed_monitor/ui/login_screen.dart';
import 'package:speed_monitor/ui/home/service_details_screen.dart';
import 'package:speed_monitor/ui/settings/service_settings_screen.dart';

import 'package:speed_monitor/ui/extras/async_value_wrapper.dart';
import 'package:speed_monitor/ui/settings/users_settings_screen.dart';

void main() async {
  await initializeDateFormatting('ru_RU', null);

  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  // ? TODO: Figure out routing
  MaterialPageRoute? routeGenerator(RouteSettings? settings) {
    if (settings == null) return null;

    if (settings.name == '/serviceDetails' && settings.arguments is Service) {
      return MaterialPageRoute(
        builder: (ctx) => ServiceDetailsScreen(settings.arguments as Service),
      );
    }

    if (settings.name == '/editService' && settings.arguments is Service) {
      return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => ServiceDetailsScreen(settings.arguments as Service),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);
    final theme = ref.watch(appThemeProvider);

    // print(user);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: theme,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        // inputDecorationTheme:
        //     const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlue,
        brightness: Brightness.dark,
        // inputDecorationTheme:
        //     const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      home: AsyncValueConnectionWrapper(
        value: user,
        onData: (userData) =>
            userData == null ? const LoginScreen() : const MainScreen(),
      ),
      routes: {
        '/settings/services': (ctx) => const ServiceSettingsScreen(),
        '/settings/users': (ctx) => const UsersSettingsScreen(),
      },
      onGenerateRoute: routeGenerator,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pageIdx,
        onDestinationSelected: (idx) => setState(() {
          _pageIdx = idx;
        }),
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Главная'),
          NavigationDestination(icon: Icon(Icons.warning), label: 'Инциденты'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Настройки'),
          // NavigationDestination(icon: Icon(Icons.track_changes), label: 'TEST'),
        ],
      ),
      body: const <Widget>[
        HomePage(),
        IncidentsPage(),
        SettingsPage(),
        // TestPage(),
      ][_pageIdx],
    );
  }
}
