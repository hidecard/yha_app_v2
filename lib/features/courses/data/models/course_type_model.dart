class CourseTypeModel {
  CourseTypeModel({this.id, this.name});

  final int? id;
  final String? name;

  factory CourseTypeModel.fromJson(Map<String, dynamic> json) {
    return CourseTypeModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }
}
