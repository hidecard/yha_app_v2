import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yha/core/theme/app_colors.dart';
import 'package:yha/core/utils/url_launcher_utils.dart';
import 'package:yha/features/courses/data/models/course_model.dart';
import 'package:yha/features/home/presentation/providers/home_providers.dart';
import 'package:yha/features/projects/data/models/project_model.dart';
import 'package:yha/shared/widgets/category_chip.dart';
import 'package:yha/shared/widgets/contact_action_button.dart';
import 'package:yha/shared/widgets/empty_state.dart';
import 'package:yha/shared/widgets/error_retry_view.dart';
import 'package:yha/shared/widgets/featured_course_card.dart';
import 'package:yha/shared/widgets/hero_banner.dart';
import 'package:yha/shared/widgets/loading_shimmer.dart';
import 'package:yha/shared/widgets/project_card.dart';
import 'package:yha/shared/widgets/stat_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(homeDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.school_rounded, size: 22),
            SizedBox(width: 8),
            Text('YHA Academy'),
          ],
        ),
      ),
      body: SafeArea(
        child: async.when(
          loading: () => ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              LoadingShimmer(height: 180, radius: 20),
              SizedBox(height: 20),
              LoadingShimmer(height: 100, radius: 16),
              SizedBox(height: 20),
              LoadingShimmer(height: 240, radius: 16),
            ],
          ),
          error: (e, _) => ErrorRetryView(
            message: 'အချက်အလက်ရယူ၍ မရသေးပါ။ အင်တာနက် connection ကိုစစ်ပြီး ပြန်လည်ကြိုးစားပါ။',
            onRetry: () => ref.invalidate(homeDataProvider),
          ),
          data: (data) {
            final courses = (data.courses).cast<CourseModel>();
            final projects = (data.projects).cast<ProjectModel>();
            final address = data.address.isNotEmpty ? data.address.first : null;
            final categories = <String>{};
            for (final c in courses) {
              final n = c.courseType?.name;
              if (n != null && n.isNotEmpty) categories.add(n);
            }
            final featured = courses.take(6).toList();
            final latestProjects = projects.take(4).toList();

            return RefreshIndicator(
              color: AppColors.primaryBlue,
              onRefresh: () async => ref.invalidate(homeDataProvider),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                children: [
                  HeroBanner(onExplore: () => context.go('/courses')),
                  const SizedBox(height: 24),
                  if (categories.isNotEmpty) ...[
                    _SectionHeader(title: 'Course Categories', icon: Icons.category_rounded),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 110,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: categories
                            .map((c) => CategoryChip(label: c, selected: false, onTap: () => context.go('/courses')))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  _SectionHeader(
                    title: 'Featured Courses',
                    icon: Icons.star_rounded,
                    action: TextButton(onPressed: () => context.go('/courses'), child: const Text('View All')),
                  ),
                  const SizedBox(height: 12),
                  if (featured.isEmpty)
                    const EmptyState()
                  else
                    SizedBox(
                      height: 290,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: featured.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 14),
                        itemBuilder: (context, i) {
                          final c = featured[i];
                          return FeaturedCourseCard(
                            course: c,
                            onTap: () {
                              if (c.id != null) context.push('/courses/${c.id}');
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'Academy at a Glance', icon: Icons.insights_rounded),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: StatCard(label: 'Courses', value: '${courses.length}', icon: Icons.menu_book_rounded)),
                      const SizedBox(width: 12),
                      Expanded(child: StatCard(label: 'Projects', value: '${projects.length}', icon: Icons.folder_special_rounded)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'Latest Student Projects',
                    icon: Icons.rocket_launch_rounded,
                    action: TextButton(onPressed: () => context.go('/projects'), child: const Text('View All')),
                  ),
                  const SizedBox(height: 12),
                  if (latestProjects.isEmpty)
                    const EmptyState()
                  else
                    ...latestProjects.map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: ProjectCard(
                            project: p,
                            onTap: () {
                              if (p.id != null) context.push('/projects/${p.id}', extra: p);
                            },
                          ),
                        )),
                  const SizedBox(height: 12),
                  _SectionHeader(title: 'Contact Shortcuts', icon: Icons.support_agent_rounded),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 6))],
                    ),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ContactActionButton(icon: Icons.phone_rounded, label: 'Call Now', onPressed: () => launchPhone(context, '09 882 328 992')),
                        ContactActionButton(icon: Icons.email_rounded, label: 'Send Email', onPressed: () => launchEmail(context, 'yhacomputer@gmail.com')),
                        if ((address?.mapUrl ?? '').isNotEmpty)
                          ContactActionButton(icon: Icons.map_rounded, label: 'Open in Maps', onPressed: () => openMap(context, address!.mapUrl)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon, this.action});
  final String title;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: AppColors.primaryBlue),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
        ?action,
      ],
    );
  }
}
