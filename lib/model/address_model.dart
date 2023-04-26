import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AddressModel {
  final String province;
  final String district;
  final String subdistrict;
  final String postcode;
  final String road;
  AddressModel({
    required this.province,
    required this.district,
    required this.subdistrict,
    required this.postcode,
    required this.road,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'province': province,
      'district': district,
      'subdistrict': subdistrict,
      'postcode': postcode,
      'road': road,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      province: (map['province'] ?? '') as String,
      district: (map['district'] ?? '') as String,
      subdistrict: (map['subdistrict'] ?? '') as String,
      postcode: (map['postcode'] ?? '') as String,
      road: (map['road'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) => AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
