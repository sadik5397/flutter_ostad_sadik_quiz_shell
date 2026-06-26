import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  const StatItem({super.key, required this.icon, required this.label, required this.value, required this.color});

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
