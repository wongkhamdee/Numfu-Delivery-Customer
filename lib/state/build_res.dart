import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numfu/screen/res.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/widgets/show_title.dart';
import 'package:numfu/widgets/widget_image_network.dart';

import '../utility/app_service.dart';

class BuildRes extends StatelessWidget {
  const BuildRes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print(
              '## restautantModels ===> ${appController.restaurantModels.length}');
          return appController.restaurantModels.isEmpty
              ? const SizedBox()
              : SizedBox(
                  height: 250,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: appController.restaurantModels.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Get.to(Res(
                          restaurantModel:
                              appController.restaurantModels[index],
                        ));
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: WidgetImageNetwork(
                                urlImage:
                                    '${MyCostant.domain}/${appController.restaurantModels[index].company_logo}',
                                size: 160,
                              ),
                            ),
                            Text(
                              appController.restaurantModels[index].res_name,
                              style: MyCostant().h3Style(),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.delivery_dining,
                                  size: 16,
                                  color: MyCostant.dark,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  ' ${appController.distanceKms[index].toStringAsFixed(1)} km',
                                  style: MyCostant().h4Style(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        });
  }
}
