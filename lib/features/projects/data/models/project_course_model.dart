class ProjectCourseModel {
  ProjectCourseModel({this.id, this.name});
  final int? id;
  final String? name;

  factory ProjectCourseModel.fromJson(Map<String, dynamic> json) {
    return ProjectCourseModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }
}
