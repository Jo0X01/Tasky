import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomCheckBox extends StatefulWidget {
  CustomCheckBox({
    super.key,
    required this.title,
    this.onChange,
    this.isCompleted = false,
  });
  final void Function(bool)? onChange;
  final String title;
  bool isCompleted;
  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange,
      child: Row(
        children: [
          Checkbox(value: widget.isCompleted, onChanged: (val) => onChange()),
          Text(widget.title),
        ],
      ),
    );
  }

  void onChange() {
    setState(() {
      widget.isCompleted = !widget.isCompleted;
      widget.onChange?.call(widget.isCompleted);
    });
  }
}
