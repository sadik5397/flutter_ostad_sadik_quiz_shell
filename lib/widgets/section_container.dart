import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer({super.key, required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant),
          ),
        ),
        Card(
          elevation: 0,
          color: colorScheme.surface,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(padding: const EdgeInsets.all(16.0), child: child),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
