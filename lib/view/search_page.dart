import 'package:flutter/material.dart';
import 'package:shopflutter/view/detail_product.dart';
import 'package:shopflutter/view/navpages/product_page.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // 1. Dùng Controller để quản lý chữ trong TextField
  final TextEditingController _controller = TextEditingController();
  String searchQuery = "";

  @override
  void dispose() {
    _controller
        .dispose(); // Hủy controller khi không dùng nữa để tránh rác bộ nhớ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = searchQuery.isEmpty
        ? ProductPage.listProduct
        : ProductPage.listProduct
              .where(
                (product) => (product.name ?? "").toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
              )
              .toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Tìm kiếm",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Tìm kiếm sản phẩm",
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                            searchQuery = "";
                          });
                        },
                        icon: Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bạn có thể thích",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),

                    filtered.isEmpty
                        ? Center(child: Text("Không tìm thấy sản phẩm"))
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.65,
                                ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 3,
                                  clipBehavior: Clip
                                      .antiAlias, // Giúp hình ảnh bo góc theo Card
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailProduct(
                                                    id: filtered[index].id,
                                                  ),
                                            ),
                                          )
                                          .then((_) {
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Stack(
                                          children: [
                                            filtered[index].image != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadiusGeometry.circular(
                                                          10,
                                                        ),
                                                    child: Image.network(
                                                      filtered[index].image!,
                                                      fit: BoxFit.cover,
                                                      height: 260,
                                                      width: double.infinity,
                                                    ),
                                                  )
                                                : const SizedBox(
                                                    height: 260,
                                                    width: double.infinity,
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                    ),
                                                  ),

                                            Positioned(
                                              right: 8,
                                              top: 8,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    filtered[index].isLike =
                                                        !(filtered[index]
                                                                .isLike ??
                                                            false);
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.white70,
                                                  child: Icon(
                                                    Icons.favorite_sharp,
                                                    color:
                                                        (filtered[index]
                                                                .isLike ??
                                                            false)
                                                        ? Colors.red
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 20,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                filtered[index].name.length > 16
                                                    ? filtered[index].name
                                                              .substring(
                                                                0,
                                                                16,
                                                              ) +
                                                          "..."
                                                    : filtered[index].name,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "${filtered[index].price.toString()}\$",
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                  ),
                                                  Text("4.5"),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
