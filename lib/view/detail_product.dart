import 'package:flutter/material.dart';
import 'package:shopflutter/view/product.dart';

class DetailProduct extends StatelessWidget {
  final int id;
  final String name;
  final double price;
  final String image;
  final String short_description;
  DetailProduct({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.short_description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Center(child: Text("$name")),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(image)),
              ),
            ),
          ),
          Center(child: Text("Giá: $price")),
          ElevatedButton(
            onPressed: () {
              dsGioHang.add(id);
            },
            child: Text("Thêm vào giỏ hàng"),
          ),
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Text("$short_description"),
          ),
        ],
      ),
    );
  }
}
