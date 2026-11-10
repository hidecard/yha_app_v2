import 'package:flutter/material.dart';
import 'package:yha/core/theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.label, required this.selected, required this.onTap, this.icon});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  IconData _iconFor(String text) {
    final t = text.toLowerCase();
    if (t.contains('web')) return Icons.language_rounded;
    if (t.contains('mobile') || t.contains('flutter') || t.contains('app')) return Icons.phone_iphone_rounded;
    if (t.contains('data') || t.contains('ai')) return Icons.psychology_rounded;
    if (t.contains('design') || t.contains('ui')) return Icons.palette_rounded;
    if (t.contains('ict') || t.contains('basic')) return Icons.computer_rounded;
    if (t.contains('all')) return Icons.apps_rounded;
    return Icons.auto_awesome_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final ic = icon ?? _iconFor(label);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 96,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryBlue : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? AppColors.primaryBlue : AppColors.border.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: (selected ? AppColors.primaryBlue : Colors.black).withValues(alpha: selected ? 0.18 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selected ? Colors.white.withValues(alpha: 0.2) : AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(ic, size: 20, color: selected ? Colors.white : AppColors.primaryBlue),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
