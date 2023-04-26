import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:numfu/model/address_model.dart';
import 'package:numfu/model/order_model.dart';
import 'package:numfu/model/product_model.dart';
import 'package:numfu/model/restaurant_model.dart';
import 'package:numfu/model/rider_model.dart';
import 'package:numfu/model/user_model.dart';
import 'package:numfu/model/wallet_model.dart';
import 'package:numfu/screen/history.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  AppController appController = Get.put(AppController());

  Future<void> findCurrentUsermodel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var datas = preferences.getStringList('datas');

    print('##16april datas at findCurrent --> $datas');

    if (datas != null) {
      String url =
          'https://www.androidthai.in.th/edumall/getCustomerWhereUser.php?isAdd=true&cust_email=${datas[5]}';
      await Dio().get(url).then((value) {
        for (var element in json.decode(value.data)) {
          UserModel userModel = UserModel.fromMap(element);
          appController.currentUserModels.add(userModel);
        }
      });
    }
  }

  Future<void> findCurrentUsermodeledit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var datas = preferences.getStringList('datas');

    print('##16april datas at findCurrent --> $datas');

    if (datas != null) {
      String url =
          'https://www.androidthai.in.th/edumall/getCustomerWhereUser.php?isAdd=true&cust_id=${datas[0]}';
      await Dio().get(url).then((value) {
        for (var element in json.decode(value.data)) {
          UserModel userModel = UserModel.fromMap(element);
          appController.currentUserModels.add(userModel);
        }
      });
    }
  }

  void processCalculatefood() {
    appController.total.value = 0;
    for (var element in appController.sqliteModels) {
      appController.total.value =
          appController.total.value + int.parse(element.sum);
    }
  }

  String calculatePriceDistance({required double distance}) {
    String priceDistance = '10';
    if (distance > 5) {
      int num = distance.round();
      num = num - 5;
      priceDistance = (10 + (num * 10)).toString();
    }
    return priceDistance;
  }

  Future<void> findOrdermodel({required String idCustomer}) async {
    if (appController.productModels.isNotEmpty) {
      appController.productModels.clear();
    }
    print('##17april datas at findCurrent --> $findOrdermodel');

    String url =
        'https://www.androidthai.in.th/edumall/customer_getOrderWhereCusId.php?isAdd=true&idCustomer=$idCustomer';
    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        for (var element in json.decode(value.data)) {
          OrderModel orderModel = OrderModel.fromMap(element);
          appController.orderModel.add(orderModel);
        }
      }
    });
  }

  Future<void> findOrdermodel1() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var datas = preferences.getStringList('datas');

    print('##16april datas at findCurrent --> $datas');

    if (datas != null) {
      String url =
          'https://www.androidthai.in.th/edumall/getCustomerWhereUser.php?isAdd=true&cust_email=${datas[5]}';
      await Dio().get(url).then((value) {
        for (var element in json.decode(value.data)) {
          UserModel userModel = UserModel.fromMap(element);
          appController.currentUserModels.add(userModel);
        }
      });
    }
  }

  Future<void> readProductWhereResId({required String res_id}) async {
    if (appController.productModels.isNotEmpty) {
      appController.productModels.clear();
    }

    String url =
        'https://www.androidthai.in.th/edumall/getFoodWhereIdRes.php?isAdd=true&res_id=$res_id';
    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        for (var element in json.decode(value.data)) {
          ProductModel productModel = ProductModel.fromMap(element);
          appController.productModels.add(productModel);
        }
      }
    });
  }

  Future<void> findPostion() async {
    Position position = await Geolocator.getCurrentPosition();
    appController.position.add(position);
  }

  Future<void> readAllRestaurant() async {
    findPostion().then((value) async {
      if (appController.restaurantModels.isNotEmpty) {
        appController.restaurantModels.clear();
      }

      String urlApi = '${MyCostant.domain}/getAllrestaurant.php';

      await Dio().get(urlApi).then((value) {
        print('## datas --> ${appController.datas}');

        print('value ==> $value');

        var rawMap = <Map<String, dynamic>>[];

        for (var element in json.decode(value.data)) {
          RestaurantModel restaurantModel = RestaurantModel.fromMap(element);
          if (restaurantModel.res_status == '1') {
            double distance = calculateDistance(
                appController.position.last.latitude,
                appController.position.last.longitude,
                double.parse(restaurantModel.latitude),
                double.parse(restaurantModel.longitude));

            // print('## distance --> $distance');

            Map<String, dynamic> map = restaurantModel.toMap();
            map['distance'] = distance;

            // print('## map --> $map');
            rawMap.add(map);

            // appController.restaurantModels.add(restaurantModel);
          }
        }

        print('### before rawMap --> $rawMap');

        rawMap.sort(
          (a, b) => a['distance'].compareTo(b['distance']),
        );

        print('### after rawMap --> $rawMap');

        for (var element in rawMap) {
          RestaurantModel model = RestaurantModel.fromMap(element);
          appController.restaurantModels.add(model);
        }
      });
    });
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  Future<AddressModel> findDataAddress(
      {required double lat, required double lng}) async {
    String urlAPI =
        'https://api.longdo.com/map/services/address?lon=$lng&lat=$lat&noelevation=1&key=cda17b2e1b8010bdfc353a0f83d59348';
    var result = await Dio().get(urlAPI);
    AddressModel addressModel = AddressModel.fromMap(result.data);
    print('## addressModel --> ${addressModel.toMap()}');
    return addressModel;
  }

  Future<void> readOrderWhereOrderId(
      {required String id, required res_id}) async {
    if (appController.orderModel.isNotEmpty) {
      appController.orderModel.clear();
      appController.resModelForListOrders.clear();
    }

    String url =
        'https://www.androidthai.in.th/edumall/customer_getOrderWhereOrderId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) async {
      if (value.toString() != 'null') {
        for (var element in json.decode(value.data)) {
          OrderModel orderModel = OrderModel.fromMap(element);
          appController.orderModel.add(orderModel);

          String url =
              'https://www.androidthai.in.th/edumall/customer_getRestaurnatWhereResid.php?isAdd=true&res_id=$res_id';
          await Dio().get(url).then((value) {
            for (var element in jsonDecode(value.data)) {
              RestaurantModel restaurantModel =
                  RestaurantModel.fromMap(element);
              appController.resModelForListOrders.add(restaurantModel);
            }
          });
        }
      }
    });
  }

  Future<void> readOrderWhereOrderIdhis(
      {required String id, required res_id}) async {
    if (appController.orderModelhis.isNotEmpty) {
      appController.orderModelhis.clear();
      appController.resModelForListOrdershis.clear();
    }

    String url =
        'https://www.androidthai.in.th/edumall/customer_getOrderWhereOrderId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) async {
      if (value.toString() != 'null') {
        for (var element in json.decode(value.data)) {
          OrderModel orderModel = OrderModel.fromMap(element);
          appController.orderModelhis.add(orderModel);

          String url =
              'https://www.androidthai.in.th/edumall/customer_getRestaurnatWhereResid.php?isAdd=true&res_id=$res_id';
          await Dio().get(url).then((value) {
            for (var element in jsonDecode(value.data)) {
              RestaurantModel restaurantModel =
                  RestaurantModel.fromMap(element);
              appController.resModelForListOrdershis.add(restaurantModel);
            }
          });
        }
      }
    });
  }

  Future<void> readOrderWhereResId() async {
    if (appController.orderModel.isNotEmpty) {
      appController.orderModel.clear();
      appController.resModelForListOrders.clear();
    }

    String urlAPi =
        'https://www.androidthai.in.th/edumall/customer_getOrderWhereCusId.php?isAdd=true&idCustomer=${appController.datas[0]}';
    await Dio().get(urlAPi).then((value) async {
      if (value.toString() != 'null') {
        for (var element in jsonDecode(value.data)) {
          OrderModel orderModel = OrderModel.fromMap(element);
          appController.orderModel.add(orderModel);
          print('URLAPI = ${orderModel.toMap()}');

          String url =
              'https://www.androidthai.in.th/edumall/customer_getRestaurnatWhereResid.php?isAdd=true&res_id=${orderModel.idShop}';
          await Dio().get(url).then((value) {
            for (var element in jsonDecode(value.data)) {
              RestaurantModel restaurantModel =
                  RestaurantModel.fromMap(element);
              appController.resModelForListOrders.add(restaurantModel);
            }
          });
        }
      }
    });
  }

  Future<void> refreshapprove() async {
    if (appController.orderModel.isNotEmpty) {
      appController.orderModel.clear();
    }

    String urlAPi =
        'https://www.androidthai.in.th/edumall/customer_refreshapprove.php?isAdd=true&idCustomer=${appController.datas[0]}';
    await Dio().get(urlAPi).then((value) async {
      if (value.toString() != 'null') {
        for (var element in jsonDecode(value.data)) {
          OrderModel orderModel = OrderModel.fromMap(element);
          appController.orderModel.add(orderModel);
          print('URLAPI = ${orderModel.toMap()}');
        }
      }
    });
  }

  Future<void> readWalletWhereCustId() async {
    if (appController.walletModel.isNotEmpty) {
      appController.walletModel.clear();
    }

    String urlAPi =
        'https://www.androidthai.in.th/edumall/customer_getWalletWhereCusId.php?isAdd=true&cust_id=${appController.datas[0]}';
    await Dio().get(urlAPi).then((value) async {
      if (value.toString() != 'null') {
        for (var element in jsonDecode(value.data)) {
          WalletModel walletModel = WalletModel.fromMap(element);
          appController.walletModel.add(walletModel);
          print('URLAPI = ${walletModel.toMap()}');
        }
      }
    });
  }

  Future<void> refreshState() async {
    if (appController.refereshStateorderModel.isNotEmpty) {
      appController.refereshStateorderModel.clear();
    }

    String urlAPi =
        'https://www.androidthai.in.th/edumall/customer_refreshapprove.php?isAdd=true&idCustomer=${appController.datas[0]}';
    await Dio().get(urlAPi).then((value) async {
      if (value.toString() != 'null') {
        for (var element in jsonDecode(value.data)) {
          OrderModel orderModel = OrderModel.fromMap(element);
          appController.refereshStateorderModel.add(orderModel);
          print('URLAPI = ${orderModel.toMap()}');
        }
      }
    });

    String urlr =
        'https://www.androidthai.in.th/edumall/customer_getRestaurnatWhereResid.php?isAdd=true&res_id=${orderModel.idShop}';
    await Dio().get(urlr).then((value) {
      for (var element in jsonDecode(value.data)) {
        RestaurantModel restaurantModel = RestaurantModel.fromMap(element);
        appController.refereshStateResModel.add(restaurantModel);
      }
    });
    String urlc =
        'https://www.androidthai.in.th/edumall/customer_getMapRiderWhereDriverId.php?isAdd=true&driver_id=${orderModel.idRidder}';
    await Dio().get(urlc).then((value) {
      for (var element in jsonDecode(value.data)) {
        RiderModel riderModel = RiderModel.fromMap(element);
        appController.refereshStateRiderModel.add(riderModel);
      }
    });
  }

  Future<void> readMapWhereOrderIdResIdUserId({required String id}) async {
    if (appController.orderMapModel.isNotEmpty) {
      appController.orderMapModel.clear();
    }

    String url =
        'https://www.androidthai.in.th/edumall/customer_getOrderWhereOrderId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) async {
      if (value.toString() != 'null') {
        for (var element in json.decode(value.data)) {
          OrderModel orderModel = OrderModel.fromMap(element);
          appController.orderMapModel.add(orderModel);

          String urlr =
              'https://www.androidthai.in.th/edumall/customer_getRestaurnatWhereResid.php?isAdd=true&res_id=${orderModel.idShop}';
          await Dio().get(urlr).then((value) {
            for (var element in jsonDecode(value.data)) {
              RestaurantModel restaurantModel =
                  RestaurantModel.fromMap(element);
              appController.resMapModelForListOrders.add(restaurantModel);
            }
          });

          String urlc =
              'https://www.androidthai.in.th/edumall/customer_getMapRiderWhereDriverId.php?isAdd=true&driver_id=${orderModel.idRidder}';
          await Dio().get(urlc).then((value) {
            for (var element in jsonDecode(value.data)) {
              RiderModel riderModel = RiderModel.fromMap(element);
              appController.riderMapModel.add(riderModel);
            }
          });
        }
      }
    });
  }
}
