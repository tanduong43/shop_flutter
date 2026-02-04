import 'package:flutter/material.dart';
import 'package:shopflutter/view/login.dart';
import 'package:shopflutter/widgets/app_buttoms.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildAvatar(),
            SizedBox(height: 10),
            Text(
              "Nguyễn Tấn Dương",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "nguyenduong43@gmail.com",
              style: TextStyle(color: Colors.grey),
            ),
            _buildMenuItem(title: "Thông tin cá nhân", icon: Icons.person),
            _buildMenuItem(title: "Đặt hàng", icon: Icons.shopping_bag),
            _buildMenuItem(title: "Địa chỉ", icon: Icons.location_on),
            _buildMenuItem(title: "Cài đặt", icon: Icons.settings),
            InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              child: AppButtoms(
                color: Colors.red,
                title: "Đăng xuất",
                width: 800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _buildMenuItem extends StatelessWidget {
  String title;
  IconData icon;
  _buildMenuItem({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 152, 198, 236),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class buildAvatar extends StatelessWidget {
  const buildAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundImage: AssetImage("assets/images/daidien.jpg"),
    );
  }
}
