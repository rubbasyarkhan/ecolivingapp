import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const TagChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: selected ? Colors.green : Colors.grey.shade300,
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
      ),
    );
  }
}
