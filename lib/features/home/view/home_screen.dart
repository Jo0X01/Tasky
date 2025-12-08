import 'package:flutter/material.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/core/utils/app_dialog.dart';
import 'package:tasky/features/auth/data/models/user_model.dart';
import 'package:tasky/features/home/data/firebase/firebase_task_actions.dart';
import 'package:tasky/features/home/data/firebase/firebase_user_actions.dart';
import 'package:tasky/features/home/data/model/task_model.dart';
import 'package:tasky/features/home/widgets/show_bottom_add_task_details_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = AppRoutes.homeScreen;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        actionsPadding: EdgeInsets.all(10),
        title: Image.asset(AssetConstant.logoImage),
        actions: [
          GestureDetector(
            onTap: _onLogoutPressed,
            child: Row(
              spacing: 10,
              children: [
                Image.asset(AssetConstant.logoutIcon, width: 24, height: 24),
                Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffFF4949),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: tasks.isEmpty
          ? _emptyListWidget
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) => _itemListWidget(index),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTaskPressed,
        backgroundColor: Color(0xff24252C),
        shape: CircleBorder(),
        child: const Icon(Icons.add, size: 30, color: Color(0xff5F33E1)),
      ),
    );
  }

  Widget _itemListWidget(int index) {
    final task = tasks[index];
    final date = DateTime.fromMillisecondsSinceEpoch(task.date ?? 0);
    return GestureDetector(
      onTap: () => _onItemTapped(task),
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xff6E6A7C)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Radio(
              side: BorderSide(color: Color(0xff5F33E1), width: 2),
              value: task.isCompleted,
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
                  "${date.day}/${date.month}/${date.year}",
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

  Widget get _emptyListWidget => SizedBox(
    width: double.infinity,
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
  );

  void _onItemTapped(TaskModel task){
    Navigator.of(context).pushNamed(AppRoutes.tasksEdit,arguments: task);
  }
  void _onAddTaskPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          ShowBottomAddTaskDetailsWidget(onSendPressed: _onSendPressed),
    );
  }

  void _onSendPressed(TaskModel task) async {
    AppDialog.showLoading(context);
    final result = await FirebaseTaskActions.addTask(task);
    AppDialog.hide(context);
    switch (result) {
      case FBResultSuccess<TaskModel>():
        AppDialog.showSuccessDialog(
          context,
          "Task added successfully",
          onDismiss: () {},
        );
        getData();
      case FBResultError():
        AppDialog.showErrorDialog(
          context,
          (result as FBResultError).errorMessage,
        );
    }
  }

  void _onLogoutPressed() async {
    AppDialog.showLoading(context);
    final result = await FirebaseUserActions.logoutUser();
    AppDialog.hide(context);
    switch (result) {
      case FBResultSuccess<UserModel>():
        Navigator.of(context).pushReplacementNamed(AppRoutes.splashScreen);
      case FBResultError<UserModel>():
        AppDialog.showErrorDialog(context, result.errorMessage);
    }
  }

  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    AppDialog.showLoading(context);
    final result = await FirebaseTaskActions.getTasks();
    AppDialog.hide(context);
    switch (result) {
      case FBResultSuccess<List<TaskModel>>():
        tasks = result.data;
        setState(() {});
      case FBResultError<List<TaskModel>>():
        AppDialog.showErrorDialog(context, result.errorMessage);
    }
  }

  @override
  void dispose() {
    super.dispose();
    tasks = [];
  }
}
