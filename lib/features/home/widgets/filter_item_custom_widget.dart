import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FilterItem extends StatefulWidget {
  final void Function(bool)? onTap;
  final String title;
  bool isSelected;
  FilterItem({
    super.key,
    required this.title,
    this.isSelected = true,
    this.onTap,
  });

  @override
  State<FilterItem> createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.isSelected = !widget.isSelected;
        widget.onTap?.call(widget.isSelected);
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: widget.isSelected ? Color(0xff5F33E1) : null,
          border: BoxBorder.all(color: Color(0xff5F33E1)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          spacing: 5,
          children: [
            Icon(
              widget.isSelected ? Icons.done : Icons.close,
              color: widget.isSelected ? Colors.white : null,
              size: 16,
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: widget.isSelected ? Colors.white : null,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
