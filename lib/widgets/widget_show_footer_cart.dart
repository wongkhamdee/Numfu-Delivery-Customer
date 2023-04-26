import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badgas;
import 'package:get/get.dart';
import 'package:numfu/screen/cart.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/my_constant.dart';

class WidgetFootercart extends StatelessWidget {
  const WidgetFootercart({super.key});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
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
              position: badgas.BadgePosition.bottomEnd(bottom: 2),
              badgeContent: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  appController.sqliteModels.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: SizedBox(
                width: size,
                height: 50,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Get.to(const Cart());
                  },
                  backgroundColor: MyCostant.primary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    ),
                  ),
                  icon: const Icon(
                    Icons.shopping_basket_outlined,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'ดูตะกร้าสินค้า',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
