import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:speed_monitor/models/service.dart';

import 'package:speed_monitor/pages/home_page.dart';
import 'package:speed_monitor/pages/incidents_page.dart';
import 'package:speed_monitor/pages/settings_page.dart';
import 'package:speed_monitor/screens/service_details_screen.dart';

import 'package:speed_monitor/test_page.dart';

void main() async {
  await initializeDateFormatting('ru_RU', null);

  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // TODO: Figure out routing
  MaterialPageRoute? routeGenerator(RouteSettings? settings) {
    if (settings != null &&
        settings.name == '/serviceDetails' &&
        settings.arguments is Service) {
      return MaterialPageRoute(
        builder: (ctx) => ServiceDetailsScreen(settings.arguments as Service),
      );
    }

    rdturn null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
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
      appBar: AppBar(
        title: const <Widget>[
          Text('Главная страница'),
          Text('Инциденты'),
          Text('Настройки'),
          Text('TEST'),
        ][_pageIdx],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pageIdx,
        onDestinationSelected: (idx) => setState(() {
          _pageIdx = idx;
        }),
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Главная'),
          NavigationDestination(icon: Icon(Icons.warning), label: 'Инциденты'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Настройки'),
          NavigationDestination(icon: Icon(Icons.track_changes), label: 'TEST'),
        ],
      ),
      body: const <Widget>[
        HomePage(),
        IncidentsPage(),
        SettingsPage(),
        TestPage(),
      ][_pageIdx],
    );
  }
}
