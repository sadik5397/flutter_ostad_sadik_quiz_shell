import 'package:flutter/material.dart';

class RankedItem extends StatelessWidget {
  const RankedItem({super.key, required this.rank, required this.imageUrl, required this.name, required this.points, required this.isMyself});

  final int rank;
  final String imageUrl;
  final String name;
  final int points;
  final bool isMyself;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isMyself ? colorScheme.primary : Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isMyself ? colorScheme.primaryContainer.withValues(alpha: 0.1) : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        leading: CircleAvatar(
          radius: 14,
          backgroundColor: colorScheme.secondaryContainer,
          child: Text(
            rank.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
        ),
        title: Row(
          spacing: 12,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: colorScheme.surfaceContainer,
              backgroundImage: NetworkImage(imageUrl),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  "$points Points",
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          isMyself ? Icons.stars_rounded : Icons.diamond,
          color: isMyself ? colorScheme.primary : Colors.pinkAccent,
        ),
      ),
    );
  }
}
