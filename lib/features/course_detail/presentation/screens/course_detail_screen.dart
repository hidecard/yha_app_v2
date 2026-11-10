import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import 'package:yha/core/error/app_failure.dart';
import 'package:yha/core/theme/app_colors.dart';
import 'package:yha/core/utils/formatters.dart';
import 'package:yha/core/utils/image_url.dart';
import 'package:yha/core/utils/url_launcher_utils.dart';
import 'package:yha/features/course_detail/presentation/providers/course_detail_providers.dart';
import 'package:yha/shared/widgets/error_retry_view.dart';
import 'package:yha/shared/widgets/loading_shimmer.dart';
import 'package:yha/shared/widgets/network_image_placeholder.dart';
import 'package:yha/shared/widgets/price_display.dart';
import 'package:yha/shared/widgets/sticky_bottom_cta.dart';

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({super.key, required this.courseId});
  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(courseDetailProvider(courseId));
    return Scaffold(
      appBar: AppBar(title: const Text('Course Detail')),
      bottomNavigationBar: StickyBottomCta(
        primaryLabel: 'Enroll Now',
        secondaryLabel: 'Contact Academy',
        onPrimary: () => _showContact(context),
        onSecondary: () => _showContact(context),
      ),
      body: SafeArea(
        child: async.when(
          loading: () => ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              LoadingShimmer(height: 220, radius: 16),
              SizedBox(height: 16),
              LoadingShimmer(height: 24, width: 220),
              SizedBox(height: 10),
              LoadingShimmer(height: 14),
              SizedBox(height: 8),
              LoadingShimmer(height: 14, width: 280),
              SizedBox(height: 16),
              LoadingShimmer(height: 120, radius: 16),
            ],
          ),
          error: (e, _) {
            final msg = e is AppFailure ? e.message : 'အချက်အလက်ရယူ၍ မရသေးပါ။';
            return ErrorRetryView(message: msg, onRetry: () => ref.invalidate(courseDetailProvider(courseId)));
          },
          data: (data) {
            final course = data.course;
            if (course == null) {
              return ErrorRetryView(message: 'အချက်အလက်မတွေ့ပါ။', onRetry: () => ref.invalidate(courseDetailProvider(courseId)));
            }
            final subjects = data.subjects ?? [];
            final related = (data.relatedCourses ?? []).where((r) => r.id != course.id).toList();
            final about = (course.about ?? '').trim();
            final links = (course.links ?? '').trim();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: NetworkImagePlaceholder(
                                  imageUrl: buildImageUrl(course.banner ?? course.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.35)],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          course.name ?? '-',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.25),
                        ),
                        const SizedBox(height: 10),
                        if ((course.description ?? '').isNotEmpty)
                          Text(course.description!, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            if (course.duration != null)
                              _MetaBadge(icon: Icons.schedule_rounded, label: '${course.duration} Hours'),
                            _MetaBadge(icon: Icons.verified_rounded, label: 'Professional Course'),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 6))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Course Fee', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                              const SizedBox(height: 6),
                              PriceDisplay(normalPrice: course.normalPrice, specialPrice: course.specialPrice),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (about.isNotEmpty)
                          _ExpandableCard(
                            title: 'About Course',
                            icon: Icons.info_outline_rounded,
                            initiallyExpanded: true,
                            child: HtmlWidget(about),
                          ),
                        if (subjects.isNotEmpty)
                          _ExpandableCard(
                            title: 'What You Will Learn',
                            icon: Icons.checklist_rounded,
                            initiallyExpanded: true,
                            child: Column(
                              children: subjects.asMap().entries.map((e) {
                                final name = e.value.subject?.name ?? '-';
                                return Container(
                                  margin: EdgeInsets.only(bottom: e.key == subjects.length - 1 ? 0 : 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySoft.withValues(alpha: 0.55),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
                                        alignment: Alignment.center,
                                        child: Text('${e.key + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        if (links.isNotEmpty)
                          _ExpandableCard(
                            title: 'External Links',
                            icon: Icons.link_rounded,
                            initiallyExpanded: false,
                            child: InkWell(
                              onTap: () => openExternalUrl(context, course.links),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.open_in_new_rounded, color: AppColors.primaryBlue),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        links,
                                        style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (related.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.auto_awesome_rounded, color: AppColors.primaryBlue, size: 20),
                              SizedBox(width: 8),
                              Text('Related Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...related.take(6).map((r) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(10),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 64,
                                      height: 64,
                                      child: NetworkImagePlaceholder(imageUrl: buildImageUrl(r.image), fit: BoxFit.cover),
                                    ),
                                  ),
                                  title: Text(r.name ?? '-', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  subtitle: r.normalPrice != null
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(formatKyat(r.normalPrice), style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
                                        )
                                      : null,
                                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.primaryBlue),
                                  onTap: () {
                                    if (r.id != null) context.push('/courses/${r.id}');
                                  },
                                ),
                              )),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showContact(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Contact Academy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 14),
              _ContactTile(icon: Icons.phone_rounded, title: 'Call Now', subtitle: '09 882 328 992', onTap: () => launchPhone(ctx, '09 882 328 992')),
              const SizedBox(height: 10),
              _ContactTile(icon: Icons.email_rounded, title: 'Send Email', subtitle: 'yhacomputer@gmail.com', onTap: () => launchEmail(ctx, 'yhacomputer@gmail.com')),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandableCard extends StatelessWidget {
  const _ExpandableCard({required this.title, required this.icon, required this.child, this.initiallyExpanded = false});
  final String title;
  final IconData icon;
  final Widget child;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.primaryBlue, size: 20),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          iconColor: AppColors.primaryBlue,
          collapsedIconColor: AppColors.textSecondary,
          children: [Align(alignment: Alignment.centerLeft, child: child)],
        ),
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: AppColors.primaryBlue),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
