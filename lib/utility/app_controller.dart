import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:numfu/model/order_model.dart';
import 'package:numfu/model/product_model.dart';
import 'package:numfu/model/restaurant_model.dart';
import 'package:numfu/model/rider_model.dart';
import 'package:numfu/model/sqlite_model.dart';
import 'package:numfu/model/user_model.dart';
import 'package:numfu/model/wallet_model.dart';

class AppController extends GetxController {
  RxList<RestaurantModel> restaurantModels = <RestaurantModel>[].obs;
  RxList<String> datas = <String>[].obs;
  RxList<Position> position = <Position>[].obs;
  RxList<ProductModel> productModels = <ProductModel>[].obs;
  RxInt amount = 1.obs;
  RxDouble distanceKm = 0.0.obs;
  RxList<double> distanceKms = <double>[].obs;
  RxList<SQLiteModel> sqliteModels = <SQLiteModel>[].obs;
  RxInt total = 0.obs;
  RxList<UserModel> currentUserModels = <UserModel>[].obs;
  RxList<OrderModel> orderModel = <OrderModel>[].obs;
  RxList<OrderModel> orderMapModel = <OrderModel>[].obs;
  RxList<RestaurantModel> resModelForListOrders = <RestaurantModel>[].obs;
  RxList<OrderModel> orderModelhis = <OrderModel>[].obs;
  RxList<RestaurantModel> resModelForListOrdershis = <RestaurantModel>[].obs;
  RxList<RestaurantModel> resMapModelForListOrders = <RestaurantModel>[].obs;
  RxList<RiderModel> riderModel = <RiderModel>[].obs;
  RxList<RiderModel> riderMapModel = <RiderModel>[].obs;
  RxList<RestaurantModel> custModelForListOrders = <RestaurantModel>[].obs;
  RxList<WalletModel> walletModel = <WalletModel>[].obs;

  RxList<OrderModel> refereshStateorderModel = <OrderModel>[].obs;
  RxList<RestaurantModel> refereshStateResModel = <RestaurantModel>[].obs;
  RxList<RiderModel> refereshStateRiderModel = <RiderModel>[].obs;
  //---------------
}
