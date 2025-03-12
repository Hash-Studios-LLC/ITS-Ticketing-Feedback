import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'bug_report_screen.dart';
import 'placeholder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 30),
                  _buildSelectionCard(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Welcome to Hash Studios Feedback Portal!',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'We value your input and are committed to improving our products',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Report Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Select one of the options below to send your report directly to the right team.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            _buildSelectionOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionOptions(BuildContext context) {
    return Column(
      children: [
        _buildSelectionOption(
          context: context,
          icon: Icons.bug_report,
          title: 'Bug Report',
          description: 'I want to report a software bug (e.g., crashes, glitches).',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BugReportScreen()),
          ),
        ),
        const SizedBox(height: 16),
        _buildSelectionOption(
          context: context,
          icon: Icons.lightbulb,
          title: 'Feature Request',
          description: 'I have a suggestion or feature request.',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlaceholderScreen(type: 'Feature Request')),
          ),
        ),
        const SizedBox(height: 16),
        _buildSelectionOption(
          context: context,
          icon: Icons.question_answer,
          title: 'General Question',
          description: 'I have a question or need help with something else.',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlaceholderScreen(type: 'General Question')),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.primaryLight,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.gray,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}