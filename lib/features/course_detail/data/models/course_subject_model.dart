import 'subject_model.dart';

class CourseSubjectModel {
  CourseSubjectModel({
    this.id,
    this.courseId,
    this.subjectId,
    this.subject,
  });

  final int? id;
  final int? courseId;
  final int? subjectId;
  final SubjectModel? subject;

  factory CourseSubjectModel.fromJson(Map<String, dynamic> json) {
    return CourseSubjectModel(
      id: json['id'] as int?,
      courseId: json['course_id'] as int?,
      subjectId: json['subject_id'] as int?,
      subject: json['subject'] is Map<String, dynamic>
          ? SubjectModel.fromJson(json['subject'] as Map<String, dynamic>)
          : null,
    );
  }
}
