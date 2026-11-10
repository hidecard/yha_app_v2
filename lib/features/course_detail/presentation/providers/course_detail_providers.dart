import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yha/core/error/app_failure.dart';
import 'package:yha/features/course_detail/data/models/course_detail_response.dart';
import 'package:yha/features/courses/data/providers.dart';

final courseDetailProvider = FutureProvider.family<CourseDetailResponse, int>((ref, id) async {
  try {
    final repo = ref.watch(courseRepositoryProvider);
    return await repo.getCourseDetail(id);
  } catch (e) {
    if (e is AppFailure) rethrow;
    throw AppFailure('အချက်အလက်ရယူ၍ မရသေးပါ။');
  }
});
