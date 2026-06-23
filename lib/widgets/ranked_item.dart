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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: isMyself ? Colors.deepPurple : Colors.transparent, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        leading: CircleAvatar(
          radius: 14,
          backgroundColor: Colors.pink.shade50,
          child: Text(rank.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        title: Row(
          spacing: 12,
          children: [
            CircleAvatar(radius: 22, backgroundColor: Colors.pink.shade50, child: Image.network(imageUrl)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("$points Points", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: Icon(isMyself ? Icons.stars_rounded : Icons.diamond, color: isMyself ? Colors.deepPurple : Colors.pinkAccent),
      ),
    );
  }
}
