import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class WalletModel {
  final String Wallet_id;
  final String cust_id;
  final String wallet_amount;
  final String dateTime;
  WalletModel({
    required this.Wallet_id,
    required this.cust_id,
    required this.wallet_amount,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Wallet_id': Wallet_id,
      'cust_id': cust_id,
      'wallet_amount': wallet_amount,
      'dateTime': dateTime,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      Wallet_id: (map['Wallet_id'] ?? '') as String,
      cust_id: (map['cust_id'] ?? '') as String,
      wallet_amount: (map['wallet_amount'] ?? '') as String,
      dateTime: (map['dateTime'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(String source) =>
      WalletModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
