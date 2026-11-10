class CourseDetailModel {
  CourseDetailModel({
    this.id,
    this.name,
    this.image,
    this.banner,
    this.description,
    this.normalPrice,
    this.specialPrice,
    this.duration,
    this.about,
    this.links,
    this.type,
  });

  final int? id;
  final String? name;
  final String? image;
  final String? banner;
  final String? description;
  final num? normalPrice;
  final num? specialPrice;
  final int? duration;
  final String? about;
  final String? links;
  final int? type;

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      banner: json['banner'] as String?,
      description: json['description'] as String?,
      normalPrice: json['normal_price'] as num?,
      specialPrice: json['special_price'] as num?,
      duration: json['duration'] as int?,
      about: json['about'] as String?,
      links: json['links'] as String?,
      type: json['type'] as int?,
    );
  }
}
