import 'package:get/get.dart';
import 'package:numfu/model/sqlite_model.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String databaseName = 'numfu.db';
  final int version = 1;
  final String tableName = 'cartTable';
  final String columnId = 'id';
  final String columnResId = 'resId';
  final String columnResName = 'resName';
  final String columnFoodName = 'foodName';
  final String columnPrice = 'price';
  final String columnAmount = 'amount';
  final String columnSum = 'sum';
  final String columnDistance = 'distance';
  final String columnDerivery = 'derivery';
  final String columnUrlImage = 'urlImage';

  SQLiteHelper() {
    initialDatabase();
  }

  Future<void> initialDatabase() async {
    await openDatabase(join(await getDatabasesPath(), databaseName),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableName ($columnId INTEGER PRIMARY KEY, $columnResId TEXT, $columnResName TEXT, $columnFoodName TEXT, $columnPrice TEXT, $columnAmount TEXT, $columnSum TEXT, $columnDistance TEXT, $columnDerivery TEXT, $columnUrlImage TEXT)'),
        version: version);
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName));
  }

  Future<void> insertData({required SQLiteModel sqLiteModel}) async {
    Database database = await connectedDatabase();
    database
        .insert(tableName, sqLiteModel.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => readData());
  }

  Future<void> readData() async {
    AppController appController = Get.put(AppController());
    if (appController.sqliteModels.isNotEmpty) {
      appController.sqliteModels.clear();
    }

    Database database = await connectedDatabase();
    var maps = await database.query(tableName);
    for (var element in maps) {
      SQLiteModel sqLiteModel = SQLiteModel.fromMap(element);
      appController.sqliteModels.add(sqLiteModel);
    }
  }

  Future<void> editData(
      {required int id, required Map<String, dynamic> map}) async {
    Database database = await connectedDatabase();
    database.update(tableName, map, where: '$columnId = $id').then((value) {
      readData().then((value) => AppService().processCalculatefood());
    });
  }

  Future<void> deleteAlldata() async {
    Database database = await connectedDatabase();
    database.delete(tableName).then((value) => readData());
  }

  Future<void> deleteWhereId({required int id}) async {
    Database database = await connectedDatabase();
    database.delete(tableName, where: '$columnId = $id').then((value) {
      return readData().then((value) => AppService().processCalculatefood());
    });
  }
}
