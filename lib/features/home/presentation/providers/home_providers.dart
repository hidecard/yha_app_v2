import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yha/features/courses/data/providers.dart';
import 'package:yha/shared/models/address_model.dart';

final homeDataProvider = FutureProvider<({List<dynamic> courses, List<dynamic> projects, List<AddressModel> address})>((ref) async {
  final courseRepo = ref.watch(courseRepositoryProvider);
  final projectRepo = ref.watch(projectRepositoryProvider);
  final coursesRes = await courseRepo.getCourses();
  final projects = await projectRepo.getProjects();
  return (courses: coursesRes.courses, projects: projects, address: coursesRes.address);
});
