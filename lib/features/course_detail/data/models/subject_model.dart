class SubjectModel {
  SubjectModel({this.id, this.name});

  final int? id;
  final String? name;

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }
}
