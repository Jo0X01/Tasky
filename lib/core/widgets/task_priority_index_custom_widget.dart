import 'package:flutter/material.dart';
import 'package:tasky/core/constant/app_constants.dart';

class TaskPriorityIndexCustomWidget extends StatelessWidget {
  const TaskPriorityIndexCustomWidget({
    super.key,
    required this.index,
    required this.isSelected,
    required this.onSelected,
  });
  final int index;
  final bool isSelected;
  final void Function(int index) onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(index),
      child: Container(
        margin: const EdgeInsets.only(left: 8, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: isSelected ? null : Border.all(color: Color(0xff6E6A7C)),
          color: isSelected ? Color(0xff5f33e1) : null,
        ),
        child: Column(
          spacing: 5,
          children: [
            Image.asset(
              AssetConstant.flagIcon,
              color: isSelected ? Colors.white : Color(0xff5F33E1),
              fit: BoxFit.contain,
              width: 24,
              height: 24,
            ),
            Text(
              "$index",
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xff404147),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
