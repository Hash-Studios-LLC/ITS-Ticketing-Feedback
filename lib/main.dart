import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/feedback_form_state.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FeedbackFormState(),
      child: const HashStudiosFeedbackPortal(),
    ),
  );
}

class HashStudiosFeedbackPortal extends StatelessWidget {
  const HashStudiosFeedbackPortal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hash Studios Feedback Portal',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}