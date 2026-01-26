import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopflutter/view/main_page.dart';
import 'package:shopflutter/view/signup.dart';
import 'package:shopflutter/widgets/app_buttoms.dart';
import 'package:shopflutter/widgets/app_textField.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorUsername;
  String? errorPassword;

  Future<void> handleLogin() async {
    // Reset lỗi trước khi kiểm tra
    setState(() {
      errorUsername = null;
      errorPassword = null;
    });

    bool isValid = true;
    if (txttendangnhap.text.isEmpty) {
      setState(() => errorUsername = "Tên đăng nhập không được để trống");
      isValid = false;
    }
    if (txtmatkhau.text.isEmpty) {
      setState(() => errorPassword = "Mật khẩu không được để trống");
      isValid = false;
    }

    if (!isValid) return;

    bool isLogin = await putData(
      txttendangnhap.text.toString(),
      txtmatkhau.text.toString(),
    );

    if (isLogin) {
      //Khi một StatefulWidget vừa được tạo ra và hiển thị lên màn hình, biến mounted sẽ được hệ thống đặt giá trị mặc định là true.
      //Biến mounted là một thuộc tính có sẵn trong lớp State của các StatefulWidget
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false,
      );
    } else {
      setState(() {
        errorUsername = ""; // Khoảng trắng để highlight đỏ ô nhập
        errorPassword = "Thông tin đăng nhập không chính xác";
      });
    }
  }

  Future<bool> putData(String tdn, String mk) async {
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

  var txttendangnhap = TextEditingController();

  var txtmatkhau = TextEditingController();

  @override
  Widget build(BuildContext context) {
    txttendangnhap.text = "duongnguyen";
    txtmatkhau.text = "123456";
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
            errorText: errorUsername,
            controller: txttendangnhap,
          ),
          AppTextfield(
            title: "Mật khẩu",
            hint: "Mật khẩu",
            isPass: true,
            errorText: errorPassword,
            controller: txtmatkhau,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: const Text(
                "Quên mật khẩu",
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ),

          InkWell(
            onTap: () async {
              handleLogin();
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
                  const TextSpan(
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

  void notificationLogin(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Thông báo"),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
