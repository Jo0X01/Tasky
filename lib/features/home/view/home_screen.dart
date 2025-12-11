import 'package:flutter/material.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/core/utils/app_dialog.dart';
import 'package:tasky/core/utils/app_helper.dart';
import 'package:tasky/core/utils/app_input_validator.dart';
import 'package:tasky/core/widgets/text_form_field_with_label_custom_widget.dart';
import 'package:tasky/features/auth/data/models/user_model.dart';
import 'package:tasky/features/home/data/firebase/firebase_task_actions.dart';
import 'package:tasky/features/home/data/firebase/firebase_user_actions.dart';
import 'package:tasky/core/models/firebase/task_model.dart';
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
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          spacing: 10,
          children: [
            TextFormFieldWithLabelCustomWidget(
              beforeIconAsset: Image.asset(AssetConstant.searchIcon),
              controller: searchTextController,
              validator: AppInputValidator.validateName,
              onChanged: _onSearchType,
              hintText: "Search",
            ),
            Row(
              spacing: 10,
              children: [
                _itemFilterWidget(
                  "Compeleted",
                  filterByCompeleted,
                  _onFilterByCompeleted,
                ),
                _itemFilterWidget(
                  "Not Compeleted",
                  filterByNotCompeleted,
                  _onFilterByNotCompeleted,
                ),
              ],
            ),
            Expanded(
              child: filteredTasks.isEmpty
                  ? _emptyListWidget
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) => _itemListWidget(index),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTaskPressed,
        backgroundColor: Color(0xff24252C),
        shape: CircleBorder(),
        child: const Icon(Icons.add, size: 30, color: Color(0xff5F33E1)),
      ),
    );
  }

  void _onFilterByNotCompeleted() {
    filterByNotCompeleted = !filterByNotCompeleted;
    _onSearchType();
  }

  void _onFilterByCompeleted() {
    filterByCompeleted = !filterByCompeleted;
    _onSearchType();
  }


  Widget _itemFilterWidget(String title, bool addIcon, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          // color: Color(0xff5F33E1),
          border: BoxBorder.all(color: Color(0xff5F33E1)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          spacing: 5,
          children: [
            Icon(addIcon ? Icons.done : Icons.close, size: 16),
            Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemListWidget(int index) {
    final task = filteredTasks[index];
    return GestureDetector(
      onTap: () => _onItemTapped(task),
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

  Widget get _emptyListWidget => SingleChildScrollView(
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

  void _onItemTapped(TaskModel task) {
    Navigator.of(context).pushNamed(AppRoutes.detailScreen, arguments: task);
  }

  void _onSearchType([String? value]) {
    value ??= searchTextController.text;
    final query = value!.toLowerCase();

    setState(() {
      filteredTasks = tasks.where((model) {
        final name = model.name?.toLowerCase();
        final desc = model.description?.toLowerCase();
        if (name == null || desc == null) return false;

        final bool isCompleted = model.isCompleted ?? false;
        if (!filterByCompeleted && !filterByNotCompeleted) {
          return false;
        }
        if (query.isNotEmpty && !(name.contains(query) || desc.contains(query))) {
          return false;
        }
        if(filterByCompeleted && filterByNotCompeleted){
          return true;
        }
        if (filterByCompeleted && !isCompleted) return false;
        if (filterByNotCompeleted && isCompleted) return false;
        return true;
      }).toList();
    });
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
  List<TaskModel> filteredTasks = [];

  late final searchTextController;
  late bool filterByCompeleted;
  late bool filterByNotCompeleted;

  @override
  void initState() {
    super.initState();
    filterByCompeleted = true;
    filterByNotCompeleted = true;
    searchTextController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  void getData() async {
    AppDialog.showLoading(context);
    final result = await FirebaseTaskActions.getTasks();
    AppDialog.hide(context);
    switch (result) {
      case FBResultSuccess<List<TaskModel>>():
        setState(() {
          tasks = result.data;
          filteredTasks = tasks;
        });
      case FBResultError<List<TaskModel>>():
        AppDialog.showErrorDialog(context, result.errorMessage);
    }
  }

  @override
  void dispose() {
    super.dispose();
    tasks = [];
    filteredTasks = [];
  }
}
