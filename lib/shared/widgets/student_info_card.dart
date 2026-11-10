import 'package:flutter/material.dart';
import 'package:yha/core/theme/app_colors.dart';
import 'package:yha/core/utils/image_url.dart';
import 'package:yha/features/projects/data/models/student_model.dart';
import 'package:yha/shared/widgets/network_image_placeholder.dart';

class StudentInfoCard extends StatelessWidget {
  const StudentInfoCard({super.key, this.student});
  final StudentModel? student;

  @override
  Widget build(BuildContext context) {
    if (student == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: NetworkImagePlaceholder(
              imageUrl: buildImageUrl(student!.image),
              height: 48,
              width: 48,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student!.name ?? '-', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                if ((student!.education ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(12)),
                      child: Text(student!.education!, style: const TextStyle(color: AppColors.primaryDark, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
