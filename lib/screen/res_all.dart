import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numfu/screen/Launcher.dart';
import 'package:numfu/screen/res.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/widgets/widget_image_network.dart';

import '../utility/app_service.dart';

class BuildResAll extends StatelessWidget {
  const BuildResAll({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return GetX(
      
        init: AppController(),
        builder: (AppController appController) {
          print(
              '## restautantModels ===> ${appController.restaurantModels.length}');
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'ร้านอาหารใกล้คุณ',
          style: MyCostant().headStyle(),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.to(Launcher());
          },
          
        ),elevation: 0,
      ),
        backgroundColor: Colors.white,
            body: appController.restaurantModels.isEmpty
                ? const Center(child: Text('No data'))
                : ListView.builder(
                    itemCount: appController.restaurantModels.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(Res(
                            restaurantModel:
                                appController.restaurantModels[index],
                          ));
                        },
                        child: Container(
                          width: size * 0.8,
                          child: Card(
                            
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: WidgetImageNetwork(
                                    urlImage:
                                        '${MyCostant.domain}/${appController.restaurantModels[index].company_logo}',
                                    size: 50,
                                  ),
                                ),
                                Text(
                                  appController.restaurantModels[index].res_name,
                                  style: MyCostant().h3Style(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    
                  ),
          );
        });
  }
}
