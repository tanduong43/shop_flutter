import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopflutter/model/product_model.dart';
import 'package:shopflutter/view/navpages/product_page.dart';

class DetailProduct extends StatelessWidget {
  final int id;
  DetailProduct({super.key, required this.id});
  Future<Productmodel?> getData() async {
    var url = Uri.parse("http://127.0.0.1:8000/api/product/$id");
    final SharedPreferences shared = await SharedPreferences.getInstance();
    String? token = shared.getString("token");
    if (token == null) return null;
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      var dataJson = jsonDecode(response.body);
      var data = dataJson['data'];
      print(data);
      return Productmodel.fromJson(data);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Center(
          child: Text(
            "Chi tiết sản phẩm",
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: FutureBuilder<Productmodel?>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Không tìm thấy sản phẩm"));
          }
          var data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    data.image,
                    width: double.maxFinite,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${data.name}",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${data.price} VNĐ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Mô tả:",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data.short_description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Align(
                  alignment: AlignmentGeometry.topCenter,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Thêm vào giỏ hàng"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
