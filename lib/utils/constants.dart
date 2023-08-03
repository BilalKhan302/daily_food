import 'dart:ui';
import 'package:flutter/material.dart';
class Constants {
  static String ?userEmail;
}

final Color primaryColor=Colors.amber;
class ConstTextForm extends StatelessWidget {
  TextEditingController controller;
  ConstTextForm({Key? key,required this.type,required this.controller,required this.label,required this.icon,required this.obsTxt}) : super(key: key);
  String label;
  Icon icon;
  bool obsTxt;
  TextInputType ?type;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsTxt,
      controller: controller,
      keyboardType: type ,

      decoration: InputDecoration(
      filled: true,
          fillColor: Colors.white.withOpacity(0.5),
          prefixIcon: icon,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white), // Set the border color to white
          ),
          label: Text(label,
          style: TextStyle(
            color: Colors.white
          ),)
      ),
    );
  }
}
