import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/widgets/show_signout.dart';
import 'package:numfu/widgets/show_title.dart';

import 'package:numfu/widgets/widget_image_network.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    AppService().findCurrentUsermodel();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return GetX(builder: (AppController appController) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: appController.currentUserModels.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(FocusNode()),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildImage(size, appController: appController),
                          const SizedBox(
                            height: 20,
                          ),
                          // buildTextname(appController: appController),
                          const SizedBox(
                            height: 20,
                          ),
                          buildEdit(size, context),
                          buildFirstname(size, appController: appController),
                          buildLastName(size, appController: appController),
                          buildPhone(size, appController: appController),
                          buildEmail(size, appController: appController),
                          ShowSignOut(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      );
    });
  }

  Row buildEdit(double size, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: size * 0.02),
          child: GestureDetector(
            onTap: () {},
            child: Text(
              'ข้อมูลของคุณ',
              style: TextStyle(
                color: MyCostant.black,
                fontSize: 26,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: size * 0.02),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, MyCostant.routeEditProfile)
                  .then((value) => AppService().findCurrentUsermodel());
            },
            child: Text(
              'แก้ไข',
              style: TextStyle(
                color: MyCostant.primary,
                fontSize: 18,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildTitle(String title) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 10, left: 8),
      child: ShowTitle(
        title: title,
        textStyle: MyCostant().h2Style(),
      ),
    );
  }

  Container buildTextname({required AppController appController}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        'สวัสดีคุณ ${appController.currentUserModels.last.cust_firstname}',
        style: MyCostant().h1pStyle(),
      ),
    );
  }

  Row buildImage(double size, {required AppController appController}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.5,
          height: size * 0.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(
                  '${MyCostant.domain}${appController.currentUserModels.last.profile_picture}'),
              fit: BoxFit.cover, // กำหนดให้รูปภาพ fit กับ container
            ),
          ),
        ),
      ],
    );
  }

  Row buildFirstname(double size, {required AppController appController}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size * 0.9,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 102, 102, 102),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'ชื่อจริง : ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size * 0.045,
                      ),
                    ),
                    SizedBox(width: size * 0.01),
                    Text(
                      appController.currentUserModels.last.cust_firstname,
                      style: TextStyle(
                        color: Color.fromARGB(255, 102, 102, 102),
                        fontSize: size * 0.045,
                      ),
                    ),
                  ],
                ),
                IconTheme(
                  data: IconThemeData(
                    color: Colors.grey, // เปลี่ยนสีเป็นเทา
                  ),
                  child: Icon(Icons.person_2_outlined),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row buildLastName(double size, {required AppController appController}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size * 0.9,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 102, 102, 102),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'นามสกุล :',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size * 0.045,
                      ),
                    ),
                    SizedBox(width: size * 0.01),
                    Text(
                      appController.currentUserModels.last.cust_lastname,
                      style: TextStyle(
                        color: Color.fromARGB(255, 102, 102, 102),
                        fontSize: size * 0.045,
                      ),
                    ),
                  ],
                ),
                IconTheme(
                  data: IconThemeData(
                    color: Colors.grey, // เปลี่ยนสีเป็นเทา
                  ),
                  child: Icon(Icons.person_2_outlined),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(double size, {required AppController appController}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size * 0.9,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 102, 102, 102),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'เบอร์ :',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size * 0.045,
                      ),
                    ),
                    SizedBox(width: size * 0.01),
                    Text(
                      appController.currentUserModels.last.cust_phone,
                      style: TextStyle(
                        color: Color.fromARGB(255, 102, 102, 102),
                        fontSize: size * 0.045,
                      ),
                    ),
                  ],
                ),
                IconTheme(
                  data: IconThemeData(
                    color: Colors.grey, // เปลี่ยนสีเป็นเทา
                  ),
                  child: Icon(Icons.phone_android),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row buildEmail(double size, {required AppController appController}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size * 0.9,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 102, 102, 102),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'อีเมล :',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size * 0.045,
                      ),
                    ),
                    SizedBox(width: size * 0.01),
                    Text(
                      appController.currentUserModels.last.cust_email,
                      style: TextStyle(
                        color: Color.fromARGB(255, 102, 102, 102),
                        fontSize: size * 0.045,
                      ),
                    ),
                  ],
                ),
                IconTheme(
                  data: IconThemeData(
                    color: Colors.grey, // เปลี่ยนสีเป็นเทา
                  ),
                  child: Icon(Icons.email),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
