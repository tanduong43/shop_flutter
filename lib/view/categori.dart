import 'package:flutter/material.dart';
import 'package:shopflutter/model/product_model.dart';
import 'package:shopflutter/view/navpages/product_page.dart'; // Đảm bảo đường dẫn này đúng với project của bạn

class Categori extends StatefulWidget {
  final List<Productmodel> ds;
  final String token;

  const Categori({super.key, required this.ds, required this.token});

  @override
  State<Categori> createState() => _CategoriState();
}

class _CategoriState extends State<Categori> {
  double _tinhTongTien() {
    double tong = 0;
    for (var item in widget.ds) {
      tong += (item.price * item.quantity);
    }
    return tong;
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Center(
          child: Text(
            "Giỏ hàng",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          // Thêm một icon rỗng để title căn giữa chuẩn hơn
          SizedBox(width: 48),
        ],
      ),

      body: widget.ds.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Giỏ hàng trống",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(
                bottom: 20,
              ), // Tránh bị che bởi bottom bar nếu danh sách dài
              itemCount: widget.ds.length,
              itemBuilder: (context, index) {
                final item = widget.ds[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported),
                              ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${item.price} VNĐ",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                _buildIconBtn(Icons.remove, () {
                                  if (item.quantity > 1) {
                                    setState(() {
                                      item.quantity--;
                                    });
                                  }
                                }),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _buildIconBtn(Icons.add, () {
                                  setState(() {
                                    item.quantity++;
                                  });
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            if (ProductPage.countItem <= 0) {
                              ProductPage.countItem = 0;
                            } else {
                              ProductPage.countItem--;
                            }
                            widget.ds.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius:
                  10, //Độ nhòe (độ mờ) của mép bóng.Số càng lớn (10, 20...): Bóng càng lan rộng ra và mờ dần đi.
              offset: const Offset(
                0,
                -5,
              ), //Vị trí của bóng so với vật thể gốc. Offset(x, y) là tọa độ (Ngang, Dọc).Trong Flutter, trục Y dương (+) là đi xuống dưới, trục Y âm (-) là đi lên trên.
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tổng tiền:",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "${_tinhTongTien()} đ",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (widget.ds.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Giỏ hàng trống!")),
                    );
                  } else {
                    print("Đặt hàng thành công! Tổng: ${_tinhTongTien()}");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "MUA HÀNG",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBtn(IconData icon, VoidCallback onPress) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18),
        onPressed: onPress,
      ),
    );
  }
}
