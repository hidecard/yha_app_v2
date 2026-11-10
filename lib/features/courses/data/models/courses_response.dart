import 'package:yha/shared/models/address_model.dart';
import 'course_model.dart';

class CoursesResponse {
  CoursesResponse({required this.courses, this.address});

  final List<CourseModel> courses;
  final List<AddressModel>? address;

  factory CoursesResponse.fromJson(Map<String, dynamic> json) {
    final coursesJson = json['courses'];
    final addressJson = json['address'];
    return CoursesResponse(
      courses: coursesJson is List
          ? coursesJson
              .whereType<Map<String, dynamic>>()
              .map(CourseModel.fromJson)
              .toList()
          : <CourseModel>[],
      address: addressJson is List
          ? addressJson
              .whereType<Map<String, dynamic>>()
              .map(AddressModel.fromJson)
              .toList()
          : null,
    );
  }
}
