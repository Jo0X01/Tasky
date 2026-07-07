import 'package:flutter/material.dart';

class SpecialIconCustomWidget extends StatelessWidget {
  const SpecialIconCustomWidget({super.key, this.onTap, required this.icon});
  final GestureTapCallback? onTap;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(left: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Color(0x366E6A7C),
        ),
        child: Image.asset(icon, width: 24, height: 24),
      ),
    );
  }
}
