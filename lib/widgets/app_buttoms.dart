import 'package:flutter/material.dart';

class AppButtoms extends StatelessWidget {
  String title;
  double height;
  double width;
  Color color;

  AppButtoms({
    super.key,
    this.title = "Đăng ký",
    this.height = 50,
    this.width = 300,
    this.color = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 50,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Center(
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}
