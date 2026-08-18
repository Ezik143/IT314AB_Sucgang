import 'package:flutter/material.dart';

/// A widget that displays a friendly message when there are no students.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.message = 'No students found.'});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 96,
            color: colors.outline,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colors.outline,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Student list is empty.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.outline,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}