import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yha/features/courses/data/models/course_model.dart';
import 'package:yha/features/courses/data/providers.dart';
import 'package:yha/shared/models/address_model.dart';
import 'package:yha/core/error/app_failure.dart';

class CoursesState {
  const CoursesState({
    this.courses = const [],
    this.addresses = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.query = '',
    this.selectedCategory,
  });

  final List<CourseModel> courses;
  final List<AddressModel> addresses;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final String query;
  final String? selectedCategory;

  CoursesState copyWith({
    List<CourseModel>? courses,
    List<AddressModel>? addresses,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
    String? query,
    String? selectedCategory,
    bool clearCategory = false,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : (error ?? this.error),
      query: query ?? this.query,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
    );
  }

  List<String> get categories {
    final set = <String>{};
    for (final c in courses) {
      final name = c.courseType?.name;
      if (name != null && name.trim().isNotEmpty) set.add(name);
    }
    final list = set.toList()..sort();
    return list;
  }

  List<CourseModel> get filteredCourses {
    final q = query.trim().toLowerCase();
    return courses.where((c) {
      final catOk = selectedCategory == null || selectedCategory!.isEmpty
          ? true
          : (c.courseType?.name ?? '') == selectedCategory;
      if (!catOk) return false;
      if (q.isEmpty) return true;
      final name = (c.name ?? '').toLowerCase();
      final typeName = (c.courseType?.name ?? '').toLowerCase();
      final desc = (c.description ?? '').toLowerCase();
      return name.contains(q) || typeName.contains(q) || desc.contains(q);
    }).toList();
  }
}

class CoursesNotifier extends StateNotifier<CoursesState> {
  CoursesNotifier(this._ref) : super(const CoursesState());

  final Ref _ref;

  Future<void> load({bool refresh = false}) async {
    if (state.isLoading) return;
    state = state.copyWith(
      isLoading: !refresh,
      isRefreshing: refresh,
      clearError: true,
    );
    try {
      final repo = _ref.read(courseRepositoryProvider);
      final data = await repo.getCourses();
      state = state.copyWith(
        courses: data.courses,
        addresses: data.address,
        isLoading: false,
        isRefreshing: false,
        clearError: true,
      );
    } catch (e) {
      final msg = e is AppFailure ? e.message : 'အချက်အလက်ရယူ၍ မရသေးပါ။';
      state = state.copyWith(isLoading: false, isRefreshing: false, error: msg);
    }
  }

  void setQuery(String q) => state = state.copyWith(query: q);
  void setCategory(String? c) {
    if (c == null || c == state.selectedCategory) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategory: c);
    }
  }
}

final coursesProvider = StateNotifierProvider<CoursesNotifier, CoursesState>((ref) {
  final n = CoursesNotifier(ref);
  n.load();
  return n;
});
