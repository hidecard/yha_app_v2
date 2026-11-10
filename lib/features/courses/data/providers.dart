import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yha/core/network/api_client.dart';
import 'package:yha/features/courses/data/course_api_service.dart';
import 'package:yha/features/courses/data/course_repository.dart';
import 'package:yha/features/projects/data/project_api_service.dart';
import 'package:yha/features/projects/data/project_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final courseApiServiceProvider = Provider<CourseApiService>(
  (ref) => CourseApiService(ref.watch(apiClientProvider)),
);

final courseRepositoryProvider = Provider<CourseRepository>(
  (ref) => CourseRepository(ref.watch(courseApiServiceProvider)),
);

final projectApiServiceProvider = Provider<ProjectApiService>(
  (ref) => ProjectApiService(ref.watch(apiClientProvider)),
);

final projectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => ProjectRepository(ref.watch(projectApiServiceProvider)),
);
