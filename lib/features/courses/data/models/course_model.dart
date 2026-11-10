import 'course_type_model.dart';

class CourseModel {
  CourseModel({
    this.id,
    this.name,
    this.image,
    this.banner,
    this.description,
    this.normalPrice,
    this.specialPrice,
    this.duration,
    this.createdAt,
    this.updatedAt,
    this.about,
    this.links,
    this.type,
    this.courseType,
  });

  final int? id;
  final String? name;
  final String? image;
  final String? banner;
  final String? description;
  final num? normalPrice;
  final num? specialPrice;
  final int? duration;
  final String? createdAt;
  final String? updatedAt;
  final String? about;
  final String? links;
  final int? type;
  final CourseTypeModel? courseType;

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      banner: json['banner'] as String?,
      description: json['description'] as String?,
      normalPrice: json['normal_price'] as num?,
      specialPrice: json['special_price'] as num?,
      duration: json['duration'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      about: json['about'] as String?,
      links: json['links'] as String?,
      type: json['type'] as int?,
      courseType: json['course_type'] is Map<String, dynamic>
          ? CourseTypeModel.fromJson(json['course_type'] as Map<String, dynamic>)
          : null,
    );
  }
}
