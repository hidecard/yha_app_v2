import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yha/core/error/app_failure.dart';
import 'package:yha/features/courses/data/providers.dart';
import 'package:yha/features/projects/data/models/project_model.dart';

class ProjectsState {
  const ProjectsState({
    this.projects = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.query = '',
    this.selectedCourse,
  });

  final List<ProjectModel> projects;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final String query;
  final String? selectedCourse;

  ProjectsState copyWith({
    List<ProjectModel>? projects,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
    String? query,
    String? selectedCourse,
    bool clearCourse = false,
  }) {
    return ProjectsState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : (error ?? this.error),
      query: query ?? this.query,
      selectedCourse: clearCourse ? null : (selectedCourse ?? this.selectedCourse),
    );
  }

  List<String> get courseFilters {
    final set = <String>{};
    for (final p in projects) {
      final name = p.course?.name;
      if (name != null && name.trim().isNotEmpty) set.add(name);
    }
    final list = set.toList()..sort();
    return list;
  }

  List<ProjectModel> get filteredProjects {
    final q = query.trim().toLowerCase();
    return projects.where((p) {
      final courseOk = selectedCourse == null || selectedCourse!.isEmpty
          ? true
          : (p.course?.name ?? '') == selectedCourse;
      if (!courseOk) return false;
      if (q.isEmpty) return true;
      final title = (p.title ?? '').toLowerCase();
      final desc = (p.desc ?? '').toLowerCase();
      final student = (p.student?.name ?? '').toLowerCase();
      final course = (p.course?.name ?? '').toLowerCase();
      return title.contains(q) || desc.contains(q) || student.contains(q) || course.contains(q);
    }).toList();
  }
}

class ProjectsNotifier extends StateNotifier<ProjectsState> {
  ProjectsNotifier(this._ref) : super(const ProjectsState());

  final Ref _ref;

  Future<void> load({bool refresh = false}) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: !refresh, isRefreshing: refresh, clearError: true);
    try {
      final repo = _ref.read(projectRepositoryProvider);
      final list = await repo.getProjects();
      state = state.copyWith(projects: list, isLoading: false, isRefreshing: false, clearError: true);
    } catch (e) {
      final msg = e is AppFailure ? e.message : 'အချက်အလက်ရယူ၍ မရသေးပါ။';
      state = state.copyWith(isLoading: false, isRefreshing: false, error: msg);
    }
  }

  void setQuery(String q) => state = state.copyWith(query: q);
  void setCourse(String? c) {
    if (c == null || c == state.selectedCourse) {
      state = state.copyWith(clearCourse: true);
    } else {
      state = state.copyWith(selectedCourse: c);
    }
  }
}

final projectsProvider = StateNotifierProvider<ProjectsNotifier, ProjectsState>((ref) {
  final n = ProjectsNotifier(ref);
  n.load();
  return n;
});
