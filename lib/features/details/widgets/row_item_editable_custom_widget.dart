import 'package:flutter/material.dart';

class RowItemEditableCustomWidget extends StatelessWidget {
  const RowItemEditableCustomWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onClick,
  });
  final String title;
  final String icon;
  final String value;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xff24252C),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        MaterialButton(
          onPressed: onClick,
          color: Color(0xff5F33E1),
          textColor: Colors.white,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          child: Row(
            spacing: 10,
            children: [
              Image.asset(icon, width: 24, height: 24, color: Colors.white),
              Text(
                value,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
