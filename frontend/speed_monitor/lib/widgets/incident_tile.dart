import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/incident.dart';

class IncidentTile extends StatelessWidget {
  IncidentTile(this.incident, {super.key});

  final Incident incident;
  final df = DateFormat.Hm('ru_RU');

  @override
  Widget build(BuildContext context) {
    // return Card.outlined(
    //   child: Padding(
    //     padding: const EdgeInsets.all(12.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Text(
    //           incident.service.name,
    //           style: Theme.of(context).textTheme.bodyLarge,
    //         ),
    //         Row(
    //           children: [
    //             Icon(Icons.access_time),
    //             Text(
    //               '${df.format(incident.timeStarted)}${incident.hasEnded ? ' - ${df.format(incident.timeEnded!)}' : ''}',
    //               style: Theme.of(context).textTheme.bodyMedium,
    //             ),
    //             Icon(Icons.speed),
    //             Text(
    //               '${incident.pingTimeAtStart}${incident.hasEnded ? ' - ${incident.pingTimeAtEnd!}' : ''}',
    //               style: Theme.of(context).textTheme.bodyMedium,
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );

    return Card.outlined(
      child: ListTile(
        isThreeLine: false,
        title: Text(incident.service.name),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '${df.format(incident.timeStarted)}${incident.hasEnded ? ' - ${df.format(incident.timeEnded!)}' : ''}',
                // style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 8.0),
            Icon(
              Icons.speed,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '${incident.pingTimeAtStart}с${incident.hasEnded ? ' - ${incident.pingTimeAtEnd!}с' : ''}',
                // style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        // subtitleTextStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
