class RelatedCourseModel {
  RelatedCourseModel({this.id, this.name, this.image, this.normalPrice});

  final int? id;
  final String? name;
  final String? image;
  final num? normalPrice;

  factory RelatedCourseModel.fromJson(Map<String, dynamic> json) {
    return RelatedCourseModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      normalPrice: json['normal_price'] as num?,
    );
  }
}
