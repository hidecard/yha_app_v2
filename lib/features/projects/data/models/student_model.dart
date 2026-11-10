class StudentModel {
  StudentModel({this.id, this.name, this.image, this.education});
  final int? id;
  final String? name;
  final String? image;
  final String? education;

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      education: json['education'] as String?,
    );
  }
}
