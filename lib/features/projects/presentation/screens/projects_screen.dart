import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yha/core/theme/app_colors.dart';
import 'package:yha/features/projects/presentation/providers/projects_providers.dart';
import 'package:yha/shared/widgets/category_chip.dart';
import 'package:yha/shared/widgets/empty_state.dart';
import 'package:yha/shared/widgets/error_retry_view.dart';
import 'package:yha/shared/widgets/loading_shimmer.dart';
import 'package:yha/shared/widgets/project_card.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectsProvider);
    final notifier = ref.read(projectsProvider.notifier);

    Widget body;
    if (state.isLoading && state.projects.isEmpty) {
      body = ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) => const Padding(padding: EdgeInsets.only(bottom: 16), child: ProjectCardShimmer()),
      );
    } else if (state.error != null && state.projects.isEmpty) {
      body = ErrorRetryView(message: state.error!, onRetry: () => notifier.load());
    } else {
      final items = state.filteredProjects;
      body = RefreshIndicator(
        color: AppColors.primaryBlue,
        onRefresh: () => notifier.load(refresh: true),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const Text('Student Projects', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            const Text('ကျောင်းသားများ၏ လက်တွေ့ Project များကို ကြည့်ရှုပါ', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Material(
              elevation: 2,
              shadowColor: Colors.black.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(28),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search projects, students, courses...',
                  prefixIcon: Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: notifier.setQuery,
              ),
            ),
            const SizedBox(height: 16),
            if (state.courseFilters.isNotEmpty)
              SizedBox(
                height: 108,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryChip(label: 'All', selected: state.selectedCourse == null, onTap: () => notifier.setCourse(null)),
                    ...state.courseFilters.map((c) => CategoryChip(
                          label: c,
                          selected: state.selectedCourse == c,
                          onTap: () => notifier.setCourse(c),
                        )),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              const EmptyState()
            else ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text('${items.length} projects found', style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              ),
              ...items.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ProjectCard(
                      project: p,
                      onTap: () {
                        if (p.id != null) context.push('/projects/${p.id}', extra: p);
                      },
                    ),
                  )),
            ],
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: SafeArea(child: body),
    );
  }
}
