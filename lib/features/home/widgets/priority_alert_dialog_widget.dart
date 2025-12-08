
import 'package:flutter/material.dart';
import 'package:tasky/features/home/widgets/task_priority_index_custom_widget.dart';

class PriorityAlertDialog extends StatelessWidget {
  PriorityAlertDialog({
    super.key,
    required this.limitPriority,
    required this.onPrioritySelected,
    this.taskPriority = 1
  });
  final int taskPriority;
  final int limitPriority;
  final void Function(int) onPrioritySelected;

  late final List<int> priorityIndexs = List.generate(
    limitPriority,
    (index) => index + 1,
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: Column(
          spacing: 10,
          children: [
            Text(
              "Task Priority",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xDE24252C),
              ),
            ),
            Divider(color: Color(0xff979797)),
            Wrap(
              children: priorityIndexs
                  .map(
                    (index) => TaskPriorityIndexCustomWidget(
                      index: index,
                      isSelected: index == taskPriority,
                      onSelected: (index) {
                        onPrioritySelected(index);
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
