import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:tasky/core/models/firebase/task_model.dart';
import 'package:tasky/core/utils/app_dialog.dart';
import 'package:tasky/core/utils/app_helper.dart';
import 'package:tasky/core/utils/app_input_validator.dart';
import 'package:tasky/core/widgets/priority_alert_dialog_widget.dart';
import 'package:tasky/core/widgets/text_form_field_with_label_custom_widget.dart';
import 'package:tasky/features/details/data/firebase/firebase_details_actions.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  static const String routeName = AppRoutes.detailScreen;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          toolbarHeight: 80,
          elevation: 0,
          title: _iconClickedWidget(AssetConstant.exitIcon, _onXTapped),
          actions: [
            _iconClickedWidget(AssetConstant.trashIcon, _onDeleteTapped),
            SizedBox(width: 5),
            _iconClickedWidget(AssetConstant.sendIcon, _onSaveTapped),
            SizedBox(width: 15),
          ],
        ),
        body: Form(
          key: validateKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
              child: Column(
                spacing: 10,
                children: [
                  TextFormFieldWithLabelCustomWidget(
                    controller: _taskNameController,
                    validator: AppInputValidator.validateName,
                    labelText: "Task Name",
                    hintText: taskModel.name,
                  ),
                  SizedBox(height: 5),
                  TextFormFieldWithLabelCustomWidget(
                    controller: _taskDescriptionController,
                    validator: AppInputValidator.validateName,
                    labelText: "Task Description",
                    hintText: taskModel.description,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: taskModel.isCompleted ?? false,
                        onChanged: (val) {
                          setState(() {
                            taskModel.isCompleted = val;
                          });
                        },
                      ),
                      Text("Mark As Compeleted"),
                    ],
                  ),
                  _itemDetailWidget(
                    "Task Date: ",
                    AssetConstant.timerIcon,
                    AppHelper.getCleanDate(
                      taskModel.date ?? DateTime.now().millisecondsSinceEpoch,
                    ),
                    _onPickDatePressed,
                  ),
                  _itemDetailWidget(
                    "Task Priority: ",
                    AssetConstant.flagIcon,
                    taskModel.priority.toString(),
                    _onSelectedPriorityPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onXTapped() {
    Navigator.of(context).pop();
  }

  void _onDeleteTapped() {
    final id = taskModel.id;
    if (id == null) {
      return _onXTapped();
    }
    AppDialog.areYouSureDialog(
      context,
      "You About to delete this task",
      () async {
        AppDialog.showLoading(context);
        final isDeleted = await FirebaseDetailsActions.delTask(id);
        AppDialog.hide(context);
        switch (isDeleted) {
          case FBResultSuccess():
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.homeScreen, (route) => false);
          case FBResultError():
            AppDialog.showErrorDialog(context, isDeleted.errorMessage);
        }
      },
    );
  }

  void _onSaveTapped() async {
    if (validateKey.currentState!.validate()) {
      taskModel.name = _taskNameController.text;
      taskModel.description = _taskDescriptionController.text;
      AppDialog.showLoading(context);
      final result = await FirebaseDetailsActions.editTask(taskModel);
      if(!mounted) return;
      AppDialog.hide(context);
      switch (result) {
        case FBResultSuccess():
          AppDialog.showSuccessDialog(context, "Success");
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(
            AppRoutes.homeScreen,
            (route) => false
          );
        case FBResultError():
          AppDialog.showErrorDialog(context, result.errorMessage);
      }
    }
  }

  void _onPickDatePressed() async {
    final sdate = DateTime.fromMillisecondsSinceEpoch(
        taskModel.date ?? DateTime.now().millisecondsSinceEpoch,
      );
    final selectedDate = await showDatePickerDialog(
      context: context,
      // initialDate: DateTime.now(),
      selectedDate: sdate,
      minDate: sdate,
      maxDate: DateTime(2050)
      // centerLeadingDate: true,
    );
    if (selectedDate != null) {
      setState(() {
        taskModel.date = selectedDate.millisecondsSinceEpoch;
      });
    }
  }

  void _onSelectedPriorityPressed() {
    showDialog(
      context: context,
      builder: (context) => PriorityAlertDialog(
        limitPriority: 10,
        taskPriority: taskModel.priority ?? 1,
        onPrioritySelected: (index) {
          setState(() {
            taskModel.priority = index;
          });
        },
      ),
    );
  }

  Widget _iconClickedWidget(String icon, void Function()? onTap) {
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

  Widget _itemDetailWidget(
    String title,
    String icon,
    String value,
    void Function() onClick,
  ) {
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

  late TextEditingController _taskNameController;
  late TextEditingController _taskDescriptionController;

  late TaskModel taskModel = TaskModel();
  var validateKey = GlobalKey<FormState>();

  var taskFormKey = GlobalKey<FormState>();
  final List<int> priorityIndexs = List.generate(10, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        setState(() {
          final arg = ModalRoute.of(context)!.settings.arguments as TaskModel;
          taskModel = TaskModel.fromJson(TaskModel.toJson(arg));
          _taskNameController = TextEditingController(text: taskModel.name);
          _taskDescriptionController = TextEditingController(text: taskModel.description);
        });
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    taskModel = TaskModel();
  }
}
