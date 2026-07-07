import 'package:flutter/material.dart';
import 'package:tasky/core/constant/app_constants.dart';

class EmptyItemsCustomWidget extends StatelessWidget {
  const EmptyItemsCustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        // width: double.infinity,
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Image.asset(AssetConstant.homeImage, fit: BoxFit.contain),
            Text(
              "What do you want to do today?",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Color(0xDE24252C),
              ),
            ),
            Text(
              "Tap + to add your tasks",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFF404147),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
