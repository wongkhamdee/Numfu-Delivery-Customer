import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badgas;
import 'package:get/get.dart';
import 'package:numfu/screen/cart.dart';
import 'package:numfu/utility/app_controller.dart';

class WidgetIconCart extends StatelessWidget {
  const WidgetIconCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      right: 10,
      child: GetX(
        init: AppController(),
        builder: (AppController appController) {
          if (appController.sqliteModels.isEmpty) {
            return const SizedBox(); // ถ้าไม่มีสินค้าในตะกร้า ให้แสดงว่างเปล่า
          } else {
            return badgas.Badge(
              position: badgas.BadgePosition.topEnd(end: -5, top: -5),
              badgeContent: Text(
                appController.sqliteModels.length.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: FloatingActionButton(
                onPressed: () {
                  Get.to(const Cart());
                },
                child:  const Icon(
                  Icons.shopping_bag_outlined,
                  size: 35,
                ),
                backgroundColor: const Color.fromARGB(255, 250, 250, 250),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
