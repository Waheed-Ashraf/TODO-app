import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final VoidCallback onAdd; // ⬅️ new

  const SectionHeader({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: onAdd,
            tooltip: 'Add Task',
          ),
        ],
      ),
    );
  }
}
