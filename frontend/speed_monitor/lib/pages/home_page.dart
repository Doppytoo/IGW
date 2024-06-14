import 'package:flutter/material.dart';

import 'package:speed_monitor/widgets/status_card.dart';
import 'package:speed_monitor/widgets/service_tile.dart';

import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/models/status.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 27,
      itemBuilder: (ctx, idx) {
        if (idx-- == 0) return const StatusCard(Status.maybe, errorCount: 5);

        return ServiceTile(
            Service(
              id: idx,
              name: 'Сайт #$idx',
              url: 'http://service$idx.example.com',
              pingThreshold: 0.5,
            ),
            0.3,
            idx % 5 == 2 ? Status.maybe : Status.good);
      },
    );
  }
}
