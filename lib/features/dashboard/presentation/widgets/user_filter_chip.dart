import 'package:flutter/material.dart';

class UserFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const UserFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: const Color(0xFF2C3E50).withValues(alpha: 0.2),
      checkmarkColor: const Color(0xFF2C3E50),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF2C3E50) : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? const Color(0xFF2C3E50) : Colors.grey[300]!,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
