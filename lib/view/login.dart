import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopflutter/view/signup.dart';
import 'package:shopflutter/view/product.dart';
import 'package:shopflutter/widgets/app_buttoms.dart';
import 'package:shopflutter/widgets/app_textField.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  Future<bool> PutData(String tdn, String mk, BuildContext context) async {
    var url = Uri.parse("http://127.0.0.1:8000/api/user/login");
    var respond = await http.post(
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      url,
      body: jsonEncode(<String, dynamic>{"username": tdn, "password": mk}),
    );
    final bodydata = respond.body;
    final databody = jsonDecode(bodydata);
    print(bodydata);
    if (respond.statusCode == 200) {
      final token = databody['access_token'];
      if (token != null) {
        final SharedPreferences shared = await SharedPreferences.getInstance();
        await shared.setString("token", token);
      }

      return true;
    }
    return false;
  }

  final txttendangnhap = TextEditingController();
  final txtmatkhau = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Đăng nhập",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppTextfield(
            title: "Tên đăng nhập",
            hint: "nguyenduong43",
            controller: txttendangnhap,
          ),
          AppTextfield(
            title: "Mật khẩu",
            hint: "Mật khẩu",
            isPass: true,
            controller: txtmatkhau,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Quên mật khẩu",
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ),

          InkWell(
            onTap: () async {
              bool isLogin = await PutData(
                txttendangnhap.text.toString(),
                txtmatkhau.text.toString(),
                context,
              );
              if (isLogin) {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => Product()));
              }
            },
            child: AppButtoms(
              title: "Đăng nhập",
              color: Colors.blue,
              height: 500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "--------------OR CONTINUE WITH--------------",
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => SigupPage()));
            },
            child: Text.rich(
              TextSpan(
                text: "Bạn không có tài khoản ",
                children: [
                  TextSpan(
                    text: "Đăng ký",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
