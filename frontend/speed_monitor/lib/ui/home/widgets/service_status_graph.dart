/*


          */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceStatusGraph extends ConsumerWidget {
  const ServiceStatusGraph({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Placeholder(
          child: SizedBox(
            height: 320,
            width: double.infinity,
            child: Center(child: Text('CHART')),
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Инциденты',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
