import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numfu/screen/login.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/utility/sqlite_helper.dart';
import 'package:numfu/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({super.key});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          width: size * 0.9,
          height: 38,
          child: ElevatedButton(
            style: MyCostant().mySignoutButtonStyle(),
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear().then((value) {
                SQLiteHelper().deleteAlldata();
                Get.offAll(const Login());
              });
            },
            child: Text(
              'ออกจากระบบ',
              style: MyCostant().h5button(),
            ),
          ),
        ),
      ],
    );
  }
}
