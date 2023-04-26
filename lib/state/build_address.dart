import 'package:flutter/material.dart';
import 'package:numfu/screen/location.dart';
import 'package:numfu/utility/my_constant.dart';

class BuildAdress extends StatelessWidget {
  const BuildAdress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110,
      color: MyCostant.primary,
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              image: const DecorationImage(
                image: AssetImage("img/delivery.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontFamily: 'MN'),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LocationMap();
              }));
            },
            child: const Text(
              'กรุณาเลือกที่อยู่',
              style: TextStyle(
                  fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
            size: 20.0,
          ),
        ],
      ),
    );
  }
}
