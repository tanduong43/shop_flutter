import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopflutter/model/product_model.dart';
import 'package:shopflutter/view/categori_page.dart';
import 'package:shopflutter/view/chat_page.dart';
import 'package:shopflutter/view/detail_product.dart';
import 'package:shopflutter/view/search_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});
  static String? token = "";
  static int countItem = 0;

  static List<Productmodel> dsGioHang = [];
  static List<Productmodel> listProduct = [];
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<Productmodel>> _productsFuture;
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  List<String> images = [
    "https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17",
    "https://images.unsplash.com/photo-1506765515384-028b60a970df",
    "https://images.unsplash.com/photo-1519125323398-675f0ddb6308",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    //Tạo 1 timer chạy lặp lại mỗi 3 giây
    //Mỗi 3 giây khối code bên trong {} sẽ được thực thi
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < 2) {
        //2 là số banner - 1.Nếu bạn có 5 banner → đổi thành 4
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage, //chuyển sang trang có index =  _currentPage
        duration: Duration(milliseconds: 400), //Thời gian chạy animation
        curve: Curves.easeInOut, //Kiểu chuyển động
      );
    });

    // 2. Chỉ gọi API một lần duy nhất khi khởi tạo Widget
    _productsFuture = GetProduct().then((products) {
      ProductPage.listProduct = products;
      return products;
    });
  }

  //Hủy timer khi thoát màn hình
  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
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
    if (response.statusCode == 200) {
      final dataJson = jsonDecode(response.body);
      final products = dataJson['data'] as List;
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
        backgroundColor: Colors.white,
        title: TextField(
          readOnly: true,
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => SearchPage()));
          },
          decoration: InputDecoration(
            hintText: "Tìm kiếm sản phẩm",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
        actions: [
          Text("${ProductPage.countItem}"),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => CategoriPage(
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
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ChatPage()));
            },
            icon: Icon(Icons.message),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              SizedBox(
                height: 160,
                width: double.infinity,
                child: PageView.builder(
                  itemCount: 3,
                  controller: _pageController,
                  onPageChanged: (index) {
                    _currentPage = index;
                  },
                  itemBuilder: (context, index) {
                    return _banner(
                      images[index],
                      "Seasonal Sale",
                      "Up to 50% off sitewide",
                    );
                  },
                ),
              ),

              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Giới thiệu",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Text(
                    "Xem tất cả",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ProductCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _banner(String image, String titleTop, String titleBottom) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Image.network(
            image,
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleTop,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(titleBottom, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<Productmodel>> ProductCard() {
    return FutureBuilder(
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
        return GridView.builder(
          // padding: const EdgeInsets.all(10),
          shrinkWrap: true, //chỉ chiếm không gian cần
          physics: NeverScrollableScrollPhysics(), // để trong tranh cuộn
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Hiển thị 2 cột
            crossAxisSpacing: 10, // Cách nhau 10px theo chiều ngang
            mainAxisSpacing: 10, // Cách nhau 10px theo chiều dọc
            childAspectRatio: 0.65, // Điều chỉnh tỉ lệ để không bị đè chữ
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductItem(context, product);
          },
        );
      },
    );
  }

  Widget _buildProductItem(BuildContext context, Productmodel product) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias, // Giúp hình ảnh bo góc theo Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => DetailProduct(id: product.id),
                ),
              )
              .then((_) {
                setState(() {});
              });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                product.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        child: Image.network(
                          product.image!,
                          fit: BoxFit.cover,
                          height: 260,
                          width: double.infinity,
                        ),
                      )
                    : const SizedBox(
                        height: 260,
                        width: double.infinity,
                        child: Icon(Icons.image_not_supported),
                      ),

                Positioned(
                  right: 8,
                  top: 8,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        product.isLike = !(product.isLike ?? false);
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Icon(
                        Icons.favorite_sharp,
                        color: (product.isLike ?? false)
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name.length > 16
                        ? product.name.substring(0, 16) + "..."
                        : product.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          "${product.price.toString()}\$",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(Icons.star, color: Colors.yellow),
                      Text("4.5"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
