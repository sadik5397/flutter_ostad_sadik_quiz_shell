import 'package:flutter/material.dart';

class PodiumItem extends StatelessWidget {
  const PodiumItem({super.key, required this.rank, required this.name, required this.points, required this.imageUrl, required this.color});

  final int rank;
  final String name;
  final int points;
  final String imageUrl;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (rank == 1) Icon(Icons.home_filled, color: color),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: CircleAvatar(radius: rank == 1 ? 50 : 40, backgroundImage: NetworkImage(imageUrl)),
              ),
              CircleAvatar(
                radius: 16,
                backgroundColor: color,
                child: Text(
                  rank.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(6) + EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Color(0xfff6f4fc),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: Color(0xff2c2199).withValues(alpha: .25), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Icon(Icons.diamond_outlined, size: 16, color: Colors.pinkAccent),
                Text(
                  points.toString(),
                  style: TextStyle(color: Color(0xff220c87), fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
