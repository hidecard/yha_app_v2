import 'project_course_model.dart';
import 'student_model.dart';

class ProjectModel {
  ProjectModel({
    this.id,
    this.courseId,
    this.studentId,
    this.title,
    this.desc,
    this.image,
    this.video,
    this.createdAt,
    this.updatedAt,
    this.course,
    this.student,
  });

  final int? id;
  final int? courseId;
  final int? studentId;
  final String? title;
  final String? desc;
  final String? image;
  final String? video;
  final String? createdAt;
  final String? updatedAt;
  final ProjectCourseModel? course;
  final StudentModel? student;

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int?,
      courseId: json['course_id'] as int?,
      studentId: json['student_id'] as int?,
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      image: json['image'] as String?,
      video: json['video'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      course: json['course'] is Map<String, dynamic>
          ? ProjectCourseModel.fromJson(json['course'] as Map<String, dynamic>)
          : null,
      student: json['student'] is Map<String, dynamic>
          ? StudentModel.fromJson(json['student'] as Map<String, dynamic>)
          : null,
    );
  }
}
