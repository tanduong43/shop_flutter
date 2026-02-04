import 'package:flutter/material.dart';
import 'package:shopflutter/view/categori_page.dart';
import 'package:shopflutter/view/chat_page.dart';
import 'package:shopflutter/view/navpages/product_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          "Thông báo",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
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

      body: Text("Thông báo"),
    );
  }
}
