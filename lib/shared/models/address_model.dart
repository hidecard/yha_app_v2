class AddressModel {
  AddressModel({
    this.id,
    this.address,
    this.openClose,
    this.yphNo,
    this.yEmail,
    this.mapUrl,
  });

  final int? id;
  final String? address;
  final String? openClose;
  final String? yphNo;
  final String? yEmail;
  final String? mapUrl;

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int?,
      address: json['address'] as String?,
      openClose: json['OpenClose'] as String?,
      yphNo: json['yphNo'] as String?,
      yEmail: json['yEmail'] as String?,
      mapUrl: json['map_url'] as String?,
    );
  }
}
