import 'package:flutter/material.dart';

/// Red background with a delete icon, revealed on right-to-left swipe.
class DeleteBackground extends StatelessWidget {
  final BorderRadius borderRadius;
  const DeleteBackground({super.key, this.borderRadius = BorderRadius.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: borderRadius),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete, color: Colors.white),
          SizedBox(height: 2),
          Text('Delete', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
