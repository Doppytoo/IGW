import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speed_monitor/models/incident.dart';
import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/widgets/incident_tile.dart';

class IncidentsPage extends StatelessWidget {
  const IncidentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMMEEEEd('ru_RU');

    return ListView.builder(
      itemCount: 25,
      itemBuilder: (ctx, idx) {
        final inc = Incident(
          id: idx,
          service: Service(
            id: idx,
            url: 'example.com',
            name: 'Сайт N',
            pingThreshold: 0.5,
          ),
          timeStarted: DateTime.now(),
          pingTimeAtStart: 0.7,
          timeEnded: DateTime.now(),
          pingTimeAtEnd: 0.3,
        );

        if (idx % 5 == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: Text(
                  toBeginningOfSentenceCase(df.format(inc.timeStarted)),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              IncidentTile(inc),
            ],
          );
        }

        return IncidentTile(inc);
      },
    );
  }
}
