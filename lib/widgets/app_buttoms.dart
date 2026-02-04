import 'package:flutter/material.dart';

class AppButtoms extends StatelessWidget {
  String title;
  double height;
  double width;
  Color color;
  Color textColor;
  Color boderColor;

  AppButtoms({
    super.key,
    this.title = "Đăng ký",
    this.height = 50,
    this.width = 300,
    this.color = Colors.green,
    this.textColor = Colors.white,
    this.boderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: boderColor),
        color: color,
      ),
      child: Center(
        child: Text(title, style: TextStyle(color: textColor, fontSize: 20)),
      ),
    );
  }
}
