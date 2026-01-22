import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopflutter/model/product_model.dart';
import 'package:shopflutter/view/categori.dart';
import 'package:shopflutter/view/detail_product.dart';

List<int> dsGioHang = [];

class Product extends StatelessWidget {
  const Product({super.key});
  static String? token = "";
  Future<List<Productmodel>> GetProduct() async {
    var url = Uri.parse("http://127.0.0.1:8000/api/products");
    final SharedPreferences shared = await SharedPreferences.getInstance();
    token = shared.getString("token");
    if (token == null) {
      return [];
    }
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final dataJson = jsonDecode(response.body);
      final products = dataJson['data'] as List;
      print(products);
      return products.map((e) => Productmodel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      print("Lỗi 401");
      return [];
    }

    return List.empty();
  }

  Future<Productmodel?> GetProduct2() async {
    var url = Uri.parse("http://127.0.0.1:8000/api/products/1");
    final SharedPreferences shared = await SharedPreferences.getInstance();
    token = shared.getString("token");
    if (token == null) return null;
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final dataJson = jsonDecode(response.body);
      final object = dataJson['data']; // <-- không phải List
      return Productmodel.fromJson(object);
    }
    return null;
  }

  static List<int> dsGioHang = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Sản phẩm")),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Categori(ds: dsGioHang, token: token!),
                ),
              );
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                border: Border.all(color: Colors.green),
              ),
              child: Center(child: Text("Giỏ hàng")),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: GetProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi tải dữ liệu: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailProduct(
                        id: product.id,
                        name: product.name,
                        price: product.price,
                        image: product.image,
                        short_description: product.short_description,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(product.image),
                          ),
                        ),
                      ),

                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Giá:${product.price.toString()}"),

                      ElevatedButton(
                        onPressed: () {
                          dsGioHang.add(product.id);
                        },
                        child: Text("Thêm vào giỏ hàng"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
