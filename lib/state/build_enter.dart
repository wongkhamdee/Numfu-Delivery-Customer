// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:numfu/screen/select_address.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/widgets/show_title.dart';

class BuildEnter extends StatelessWidget {
  const BuildEnter({
    Key? key,
    required this.size,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  final double size;
  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.9,
          child: ElevatedButton(
            style: MyCostant().myButtonStyle(),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Select_a(lat: lat, lng: lng,);
              }));
            },
            child: ShowTitle(
              title: 'เพิ่มที่อยู่',
              textStyle: MyCostant().h5button(),
            ),
          ),
        ),
      ],
    );
  }
}
