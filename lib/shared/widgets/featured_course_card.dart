import 'package:flutter/material.dart';
import 'package:yha/core/theme/app_colors.dart';
import 'package:yha/core/utils/image_url.dart';
import 'package:yha/features/courses/data/models/course_model.dart';
import 'package:yha/shared/widgets/network_image_placeholder.dart';

class FeaturedCourseCard extends StatelessWidget {
  const FeaturedCourseCard({super.key, required this.course, required this.onTap});
  final CourseModel course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final typeName = course.courseType?.name ?? '';
    return SizedBox(
      width: 260,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    NetworkImagePlaceholder(
                      imageUrl: buildImageUrl(course.image),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: _Badge(label: typeName.isNotEmpty ? typeName : 'Course', icon: Icons.school_rounded),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary, height: 1.3),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (course.duration != null)
                          _MetaPill(icon: Icons.schedule_rounded, label: '${course.duration}h'),
                        _MetaPill(
                          icon: Icons.payments_outlined,
                          label: _priceLabel(),
                          highlight: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _priceLabel() {
    final p = course.specialPrice ?? course.normalPrice;
    if (p == null) return 'Contact';
    return 'Ks ${(p / 1000).round()}k';
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.icon});
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8)],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: AppColors.primaryBlue),
        const SizedBox(width: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 140),
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryDark, fontSize: 11, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label, this.highlight = false});
  final IconData icon;
  final String label;
  final bool highlight;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primarySoft : AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: highlight ? AppColors.primaryBlue.withValues(alpha: 0.2) : AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: AppColors.primaryBlue),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: highlight ? AppColors.primaryDark : AppColors.textSecondary)),
      ]),
    );
  }
}
