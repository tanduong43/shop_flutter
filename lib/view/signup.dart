import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopflutter/widgets/app_buttoms.dart';
import 'package:shopflutter/widgets/app_textField.dart';

class SigupPage extends StatelessWidget {
  SigupPage({super.key});
  final txtTtdn = TextEditingController();
  final txtTmk = TextEditingController();
  final txtFullName = TextEditingController();
  final txtSex = TextEditingController();
  final txtDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Center(
          child: Text(
            "Đăng ký",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          AppTextfield(
            title: "Tên đăng nhập",
            hint: "nguyenduong43",
            controller: txtTtdn,
          ),
          AppTextfield(
            title: "Mật khẩu",
            hint: "Mật khẩu",
            isPass: true,
            controller: txtTmk,
          ),
          AppTextfield(
            title: "Họ và tên",
            hint: "Nguyễn Văn A",
            controller: txtFullName,
          ),
          AppTextfield(title: "Giới tính", hint: "Nam/Nữ", controller: txtSex),
          AppTextfield(
            title: "Ngày sinh",
            hint: "yyyy-mm-dd",
            controller: txtDate,
          ),
          SizedBox(height: 20),
          Center(
            child: InkWell(
              onTap: () async {
                await PutData(
                  txtTtdn.text,
                  txtTmk.text,
                  txtFullName.text,
                  txtDate.text,
                  txtSex.text,
                  context,
                );
              },
              child: AppButtoms(title: "Đăng ký"),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> PutData(
  String tdn,
  String mk,
  String name,
  String date,
  String gender,
  BuildContext context,
) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/user/register');
  print(name);

  final respond = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "fullname": name,
      "username": tdn,
      "password": mk,
      "gender": gender,
      "dob": date,
    }),
  );
  print('Response: ${respond.body}');

  if (respond.statusCode == 201) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Đăng ký thành công"),
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
  } else {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text("Đăng ký thất bại: ${respond.body}")),
    );
  }
}
