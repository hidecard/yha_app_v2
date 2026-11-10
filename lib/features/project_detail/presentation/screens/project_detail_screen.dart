import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yha/core/theme/app_colors.dart';
import 'package:yha/core/utils/formatters.dart';
import 'package:yha/core/utils/image_url.dart';
import 'package:yha/core/utils/url_launcher_utils.dart';
import 'package:yha/features/projects/data/models/project_model.dart';
import 'package:yha/features/projects/presentation/providers/projects_providers.dart';
import 'package:yha/shared/widgets/error_retry_view.dart';
import 'package:yha/shared/widgets/network_image_placeholder.dart';
import 'package:yha/shared/widgets/student_info_card.dart';

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId, this.project});
  final int projectId;
  final ProjectModel? project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ProjectModel? p = project;
    final state = ref.watch(projectsProvider);
    if (p == null) {
      if (state.isLoading && state.projects.isEmpty) {
        return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
      }
      if (state.error != null && state.projects.isEmpty) {
        return Scaffold(
          appBar: AppBar(),
          body: ErrorRetryView(message: state.error!, onRetry: () => ref.read(projectsProvider.notifier).load()),
        );
      }
      try {
        p = state.projects.firstWhere((e) => e.id == projectId);
      } catch (_) {
        p = null;
      }
    }

    if (p == null) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorRetryView(message: 'အချက်အလက်မတွေ့ပါ။', onRetry: () => ref.read(projectsProvider.notifier).load()),
      );
    }

    final proj = p;
    final desc = proj.desc ?? '';
    final hasVideo = (proj.video ?? '').trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Project Detail')),
      bottomNavigationBar: hasVideo
          ? SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: const Border(top: BorderSide(color: AppColors.border)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => openExternalUrl(context, proj.video),
                  icon: const Icon(Icons.play_circle_fill_rounded),
                  label: const Text('Watch Project Video'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    NetworkImagePlaceholder(imageUrl: buildImageUrl(proj.image), fit: BoxFit.cover),
                    if (hasVideo)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.35), shape: BoxShape.circle),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 34),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(proj.title ?? '-', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.25)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if ((proj.course?.name ?? '').isNotEmpty)
                  _Tag(icon: Icons.school_rounded, label: proj.course!.name!),
                if ((proj.createdAt ?? '').isNotEmpty)
                  _Tag(icon: Icons.calendar_today_rounded, label: formatDate(proj.createdAt)),
              ],
            ),
            const SizedBox(height: 16),
            if (proj.student != null) ...[
              const _SectionTitle(icon: Icons.person_rounded, title: 'Student'),
              const SizedBox(height: 10),
              StudentInfoCard(student: proj.student),
              const SizedBox(height: 16),
            ],
            if (desc.isNotEmpty)
              _InfoCard(
                title: 'Project Description',
                icon: Icons.description_rounded,
                child: _ExpandableText(text: desc),
              ),
            _InfoCard(
              title: 'Project Info',
              icon: Icons.info_outline_rounded,
              child: Column(
                children: [
                  _InfoRow(label: 'Course', value: proj.course?.name ?? '-'),
                  const SizedBox(height: 10),
                  _InfoRow(label: 'Created', value: formatDate(proj.createdAt).isNotEmpty ? formatDate(proj.createdAt) : '-'),
                  const SizedBox(height: 10),
                  _InfoRow(label: 'Video', value: hasVideo ? 'Available' : 'Not available'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: AppColors.primaryBlue),
      ),
      const SizedBox(width: 10),
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    ]);
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.icon, required this.child});
  final String title;
  final IconData icon;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ]),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 15, color: AppColors.primaryBlue),
        const SizedBox(width: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 240),
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 90, child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500))),
      Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
    ]);
  }
}

class _ExpandableText extends StatefulWidget {
  const _ExpandableText({required this.text});
  final String text;
  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final showToggle = widget.text.length > 180;
    final visible = (!showToggle || expanded) ? widget.text : '${widget.text.substring(0, 180)}...';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(visible, style: const TextStyle(color: AppColors.textSecondary, height: 1.6)),
      if (showToggle)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: TextButton.icon(
            onPressed: () => setState(() => expanded = !expanded),
            icon: Icon(expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, size: 18),
            label: Text(expanded ? 'Read Less' : 'Read More'),
          ),
        ),
    ]);
  }
}
