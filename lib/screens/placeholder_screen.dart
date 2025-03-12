import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlaceholderScreen extends StatelessWidget {
  final String type;

  const PlaceholderScreen({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final IconData icon = type == 'Feature Request' ? Icons.lightbulb : Icons.question_answer;

    return Scaffold(
      appBar: AppBar(
        title: Text(type),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 72,
                color: AppTheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                '$type Form',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const Text(
                'This form is currently under development. Please check back later.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Selection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}