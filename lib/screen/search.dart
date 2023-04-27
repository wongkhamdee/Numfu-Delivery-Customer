import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:numfu/screen/menu.dart';
import 'package:numfu/screen/res.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/widgets/widget_image_network.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    searchFocusNode.requestFocus();
  }

  String searchQuery = '';
  final _textSearchController = TextEditingController();
  final searchFocusNode = FocusNode();
  @override
  void dispose() {
    _textSearchController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> searchProducts(String searchQuery) async {
    if (searchQuery == null || searchQuery.isEmpty) {
      // ถ้า searchQuery เป็น null หรือ empty string ให้ return ผลลัพธ์เป็น empty list
      return [];
    }
    final response = await http.get(Uri.parse(
        'https://www.androidthai.in.th/edumall/customer_searchRestaurantandProduct.php?isAdd=true&food_name=${Uri.encodeComponent(searchQuery)}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              controller: _textSearchController,
              focusNode: searchFocusNode,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _textSearchController.clear();
                  },
                ),
                hintText: 'ค้นหา...',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    searchQuery = value;
                  });
                }
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: searchQuery.isEmpty
            ? Future.value([])
            : searchProducts(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('ไม่เจอร้านหรืออาหารที่คุณต้องการ'),
            );
          }

          final results = snapshot.data;

          if (results == null || results.isEmpty) {
            return Center(
              child: Text('กรุณากรอกเมนูที่คุณต้องการ'),
            );
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final product = results[index];
              return GetBuilder<AppController>(
                init: AppController(),
                builder: (AppController appController) {
                  return ListTile(
                    leading: WidgetImageNetwork(
                      urlImage: '${MyCostant.domain}${product['company_logo']}',
                      size: 100,
                      width: 100,
                    ),
                    title: Text(product['res_name']),
                    subtitle: Text(product['complete_address']),
                    onTap: () {
                      var selectedRestaurant = appController.restaurantModels
                          .firstWhere((res) => res.res_id == product['res_id']);
                      Get.to(Res(
                        restaurantModel: selectedRestaurant,
                      ));
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
