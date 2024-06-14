import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Theme.of(context).colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.gpp_maybe,
                color: Theme.of(context).colorScheme.onErrorContainer,
                size: 96.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kinda good',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Investigate'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
