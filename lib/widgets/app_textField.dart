import 'package:flutter/material.dart';

class AppTextfield extends StatefulWidget {
  TextEditingController controller;
  String title;
  String hint;
  bool isPass;

  AppTextfield({
    super.key,
    required this.title,
    required this.hint,
    this.isPass = false,
    required this.controller,
  });

  @override
  State<AppTextfield> createState() => _AppTextfieldState();
}

bool is_ob = true;

class _AppTextfieldState extends State<AppTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          TextField(
            obscureText: widget.isPass ? is_ob : false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hint: Text(widget.hint, style: TextStyle(color: Colors.grey)),
              suffixIcon: widget.isPass
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          is_ob = !is_ob;
                        });
                      },
                      icon: Icon(
                        is_ob ? Icons.visibility_off : Icons.visibility,
                      ),
                    )
                  : null,
            ),
            controller: widget.controller,
          ),
        ],
      ),
    );
  }
}
