import 'package:flutter/material.dart';
import 'package:yha/core/theme/app_colors.dart';
import 'package:yha/core/utils/image_url.dart';
import 'package:yha/core/utils/url_launcher_utils.dart';
import 'package:yha/features/projects/data/models/project_model.dart';
import 'package:yha/shared/widgets/network_image_placeholder.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, required this.onTap});
  final ProjectModel project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasVideo = (project.video ?? '').trim().isNotEmpty;
    final studentName = project.student?.name ?? '';
    return Card(
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
                    imageUrl: buildImageUrl(project.image),
                    fit: BoxFit.cover,
                  ),
                  if ((project.course?.name ?? '').isNotEmpty)
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          project.course!.name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.primaryDark, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  if (hasVideo)
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: InkWell(
                        onTap: () => openExternalUrl(context, project.video),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: AppColors.primaryBlue.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.title ?? '-', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary, height: 1.3)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _Avatar(image: project.student?.image, name: studentName),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(studentName.isNotEmpty ? studentName : '-', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            if ((project.student?.education ?? '').isNotEmpty)
                              Text(project.student!.education!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      TextButton(onPressed: onTap, child: const Text('View')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.image, required this.name});
  final String? image;
  final String name;
  @override
  Widget build(BuildContext context) {
    final url = buildImageUrl(image);
    if (url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: NetworkImagePlaceholder(imageUrl: url, height: 40, width: 40),
      );
    }
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primarySoft,
      child: Text(initial, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
    );
  }
}
