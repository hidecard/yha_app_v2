import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yha/core/theme/app_colors.dart';
import 'package:yha/features/courses/presentation/providers/courses_providers.dart';
import 'package:yha/shared/widgets/category_chip.dart';
import 'package:yha/shared/widgets/course_card.dart';
import 'package:yha/shared/widgets/empty_state.dart';
import 'package:yha/shared/widgets/error_retry_view.dart';
import 'package:yha/shared/widgets/loading_shimmer.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coursesProvider);
    final notifier = ref.read(coursesProvider.notifier);

    Widget body;
    if (state.isLoading && state.courses.isEmpty) {
      body = ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) => const Padding(padding: EdgeInsets.only(bottom: 16), child: CourseCardShimmer()),
      );
    } else if (state.error != null && state.courses.isEmpty) {
      body = ErrorRetryView(message: state.error!, onRetry: () => notifier.load());
    } else {
      final items = state.filteredCourses;
      body = RefreshIndicator(
        color: AppColors.primaryBlue,
        onRefresh: () => notifier.load(refresh: true),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const Text('Explore Courses', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            const Text('သင့်အနာဂတ်အတွက် သင့်တော်သော သင်တန်းကို ရွေးချယ်ပါ', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Material(
              elevation: 2,
              shadowColor: Colors.black.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(28),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search courses, categories...',
                  prefixIcon: Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: notifier.setQuery,
              ),
            ),
            const SizedBox(height: 16),
            if (state.categories.isNotEmpty)
              SizedBox(
                height: 108,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryChip(label: 'All', selected: state.selectedCategory == null, onTap: () => notifier.setCategory(null)),
                    ...state.categories.map((c) => CategoryChip(
                          label: c,
                          selected: state.selectedCategory == c,
                          onTap: () => notifier.setCategory(c),
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
                child: Text('${items.length} courses found', style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              ),
              ...items.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CourseCard(
                      course: c,
                      onTap: () {
                        if (c.id != null) context.push('/courses/${c.id}');
                      },
                    ),
                  )),
            ],
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: SafeArea(child: body),
    );
  }
}
