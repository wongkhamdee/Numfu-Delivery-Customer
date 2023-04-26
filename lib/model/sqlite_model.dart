import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SQLiteModel {
  final int? id;
  final String resId;
  final String resName;
  final String foodName;
  final String price;
  final String amount;
  final String sum;
  final String distance;
  final String derivery;
  final String urlImage;
  SQLiteModel({
    this.id,
    required this.resId,
    required this.resName,
    required this.foodName,
    required this.price,
    required this.amount,
    required this.sum,
    required this.distance,
    required this.derivery,
    required this.urlImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'resId': resId,
      'resName': resName,
      'foodName': foodName,
      'price': price,
      'amount': amount,
      'sum': sum,
      'distance': distance,
      'derivery': derivery,
      'urlImage': urlImage,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: map['id'] != null ? map['id'] as int : null,
      resId: map['resId'] as String,
      resName: map['resName'] as String,
      foodName: map['foodName'] as String,
      price: map['price'] as String,
      amount: map['amount'] as String,
      sum: map['sum'] as String,
      distance: map['distance'] as String,
      derivery: map['derivery'] as String,
      urlImage: map['urlImage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) =>
      SQLiteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
