import 'package:flutter/material.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/models/firebase/task_model.dart';
import 'package:tasky/core/utils/app_helper.dart';
import 'package:tasky/features/details/view/details_screen.dart';

class ItemCardCustomWidget extends StatelessWidget {
  const ItemCardCustomWidget({super.key, required this.task});

  final TaskModel task;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).pushNamed(DetailsScreen.routeName, arguments: task),
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xff6E6A7C)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              child: Icon(
                task.isCompleted ?? false
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: Color(0xff5F33E1),
                size: 24,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                Text(
                  task.name ?? "",
                  style: TextStyle(
                    color: Color(0xff24252C),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  AppHelper.getCleanDate(task.date),
                  style: TextStyle(
                    color: Color(0xff6E6A7C),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(top: 30, right: 11, bottom: 4),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: BoxBorder.all(color: Color(0xff5F33E1)),
              ),
              child: Row(
                spacing: 5,
                children: [
                  Image.asset(AssetConstant.flagIcon, width: 14, height: 14),
                  Text(
                    "${task.priority}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff24252C),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
