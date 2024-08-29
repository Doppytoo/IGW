import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_monitor/models/service.dart';

class ServiceDetailsScreen extends ConsumerWidget {
  const ServiceDetailsScreen(this.service, {super.key});

  final Service service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.name),
      ),
      body: Placeholder(),
    );
  }
}
