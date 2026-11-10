import 'package:yha/shared/models/address_model.dart';
import 'course_detail_model.dart';
import 'course_subject_model.dart';
import 'related_course_model.dart';

class CourseDetailResponse {
  CourseDetailResponse({
    this.course,
    this.subjects,
    this.relatedCourses,
    this.address,
  });

  final CourseDetailModel? course;
  final List<CourseSubjectModel>? subjects;
  final List<RelatedCourseModel>? relatedCourses;
  final List<AddressModel>? address;

  factory CourseDetailResponse.fromJson(Map<String, dynamic> json) {
    return CourseDetailResponse(
      course: json['course'] is Map<String, dynamic>
          ? CourseDetailModel.fromJson(json['course'] as Map<String, dynamic>)
          : null,
      subjects: json['subjects'] is List
          ? (json['subjects'] as List)
              .whereType<Map<String, dynamic>>()
              .map(CourseSubjectModel.fromJson)
              .toList()
          : null,
      relatedCourses: json['relatedCourses'] is List
          ? (json['relatedCourses'] as List)
              .whereType<Map<String, dynamic>>()
              .map(RelatedCourseModel.fromJson)
              .toList()
          : null,
      address: json['address'] is List
          ? (json['address'] as List)
              .whereType<Map<String, dynamic>>()
              .map(AddressModel.fromJson)
              .toList()
          : null,
    );
  }
}
