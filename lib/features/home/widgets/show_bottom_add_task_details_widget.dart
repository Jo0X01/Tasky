import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/utils/app_helper.dart';
import 'package:tasky/core/utils/app_input_validator.dart';
import 'package:tasky/core/widgets/text_form_field_with_label_custom_widget.dart';
import 'package:tasky/core/models/firebase/task_model.dart';
import 'package:tasky/core/widgets/priority_alert_dialog_widget.dart';

class ShowBottomAddTaskDetailsWidget extends StatefulWidget {
  const ShowBottomAddTaskDetailsWidget({
    super.key,
    required this.onSendPressed,
  });
  final void Function(TaskModel) onSendPressed;

  @override
  State<ShowBottomAddTaskDetailsWidget> createState() =>
      _ShowBottomAddTaskDetailsWidgetState();
}

class _ShowBottomAddTaskDetailsWidgetState
    extends State<ShowBottomAddTaskDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: taskFormKey,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // keyboard height
            left: 24,
            right: 24,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                "Add Task",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color(0xDE24252C),
                ),
              ),
              TextFormFieldWithLabelCustomWidget(
                controller: _taskNameController,
                validator: AppInputValidator.validateName,
                hintText: "Enter Task Name",
              ),
              TextFormFieldWithLabelCustomWidget(
                controller: _taskDescriptionController,
                validator: AppInputValidator.validateName,
                hintText: "Enter Task Description",
              ),
              SizedBox(height: 10),
              Row(
                spacing: 12,
                children: [
                  _clickableIconWithLabel(
                    AssetConstant.timerIcon,
                    AppHelper.getCleanDate(_taskDate.millisecondsSinceEpoch),
                    _onPickDatePressed,
                  ),
                  _clickableIconWithLabel(
                    AssetConstant.flagIcon,
                    "$_taskPriority",
                    _onSelectedPriorityPressed,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _onSendPressed,
                    child: Image.asset(
                      AssetConstant.sendIcon,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  void _onPickDatePressed() async {
    final selectedDate = await showDatePickerDialog(
      context: context,
      initialDate: DateTime.now(),
      selectedDate: _taskDate,
      minDate: DateTime.now(),
      maxDate: DateTime(2050),
      centerLeadingDate: true,
    );
    if (selectedDate != null) {
      setState(() {
        _taskDate = selectedDate;
      });
    }
  }

  void _onSelectedPriorityPressed() {
    showDialog(
      context: context,
      builder: (context) => PriorityAlertDialog(
        limitPriority: 10,
        taskPriority: _taskPriority,
        onPrioritySelected: (index) {
          setState(() {
            _taskPriority = index;
          });
        },
      ),
    );
  }

  void _onSendPressed() async {
    if (taskFormKey.currentState!.validate()) {
      final task = TaskModel(
        name: _taskNameController.text,
        description: _taskDescriptionController.text,
        date: _taskDate.millisecondsSinceEpoch,
        priority: _taskPriority,
        isCompleted: false,
      );
      Navigator.of(context).pop();
      widget.onSendPressed(task);
    }
  }

  Widget _clickableIconWithLabel(
    String imagePath,
    String? label,
    void Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff5F33E1)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: 5,
          children: [
            Image.asset(imagePath, width: 20, height: 20),
            Text("$label", style: TextStyle(color: Color(0xff5F33E1))),
          ],
        ),
      ),
    );
  }

  late TextEditingController _taskNameController;
  late TextEditingController _taskDescriptionController;

  var taskFormKey = GlobalKey<FormState>();
  DateTime _taskDate = DateTime.now();
  int _taskPriority = 1;
  final List<int> priorityIndexs = List.generate(10, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController();
    _taskDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
  }
}
