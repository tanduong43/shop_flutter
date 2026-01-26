import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopflutter/model/product_model.dart';
import 'package:shopflutter/view/categori.dart';
import 'package:shopflutter/view/detail_product.dart';

// List<int> dsGioHang = [];

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});
  static String? token = "";
  static int countItem = 0;

  static List<Productmodel> dsGioHang = [];

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<Productmodel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    // 2. Chỉ gọi API một lần duy nhất khi khởi tạo Widget
    _productsFuture = GetProduct();
  }

  Future<List<Productmodel>> GetProduct() async {
    var url = Uri.parse("http://127.0.0.1:8000/api/products");
    final SharedPreferences shared = await SharedPreferences.getInstance();
    ProductPage.token = shared.getString("token");
    if (ProductPage.token == null || ProductPage.token!.isEmpty) {
      return [];
    }
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${ProductPage.token}',
        'Accept': 'application/json',
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final dataJson = jsonDecode(response.body);
      final products = dataJson['data'] as List;
      print(products);
      return products.map((e) => Productmodel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      return [];
    }
    return List.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Sản phẩm"),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        actions: [
          Text("${ProductPage.countItem}"),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => Categori(
                          ds: ProductPage.dsGioHang,
                          token: ProductPage.token!,
                        ),
                      ),
                    )
                    .then((_) {
                      setState(() {});
                    });
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _productsFuture,
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
          if (!snapshot.hasData) {
            return Center(child: const Text("Lỗi"));
          }
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductItem(context, product);
            },
          );
        },
      ),
    );
  }

  InkWell _buildProductItem(BuildContext context, Productmodel product) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailProduct(id: product.id),
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
                image: DecorationImage(image: NetworkImage(product.image)),
              ),
            ),

            Text(
              product.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Giá:${product.price.toString()}"),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  int index = ProductPage.dsGioHang.indexWhere(
                    (item) => item.id == product.id,
                  );
                  if (index != -1) {
                    ProductPage.dsGioHang[index].quantity++;
                  } else {
                    ProductPage.countItem++;
                    print("${ProductPage.countItem}");
                    ProductPage.dsGioHang.add(product);
                  }
                });
              },
              child: Text("Thêm vào giỏ hàng"),
            ),
          ],
        ),
      ),
    );
  }
}
