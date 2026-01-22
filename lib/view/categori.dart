import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopflutter/model/product_model.dart';

class Categori extends StatelessWidget {
  final List<int> ds;
  final String token;
  const Categori({super.key, required this.ds, required this.token});
  Future<List<Productmodel>> getProductInCate(int index) async {
    var url = Uri.parse("http://127.0.0.1:8000/api/product/${index}");

    var reponse = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${token}',
        'Accept': 'application/json',
      },
    );
    if (reponse.statusCode == 200) {}
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("Giỏ hàng"));
  }
}
