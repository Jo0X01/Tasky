import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/models/firebase/task_model.dart';
import 'package:tasky/core/utils/app_dialog.dart';
import 'package:tasky/core/utils/app_input_validator.dart';
import 'package:tasky/core/widgets/priority_alert_dialog_widget.dart';
import 'package:tasky/core/widgets/text_form_field_with_label_custom_widget.dart';
import 'package:tasky/features/details/cubits/action_cubit/action_cubit.dart';
import 'package:tasky/features/details/widgets/custom_checkbox.dart';
import 'package:tasky/features/details/widgets/row_item_editable_custom_widget.dart';
import 'package:tasky/features/details/widgets/special_icon_custom_widget.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  static const String routeName = AppRoutes.detailScreen;

  @override
  Widget build(BuildContext context) {
    final model = ModalRoute.of(context)!.settings.arguments as TaskModel;
    return BlocProvider(
      create: (context) => DetailsActionCubit(model),
      child: const DetailsView(),
    );
  }
}

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

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
          title: SpecialIconCustomWidget(
            icon: AssetConstant.exitIcon,
            onTap: Navigator.of(context).pop,
          ),
          actions: [
            BlocConsumer<DetailsActionCubit, DetailsActionState>(
              listener: (context, state) {
                if (state is ActionDetailsDeleteSuccessState) {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(AppRoutes.homeScreen);
                } else if (state is ActionDetailsDeleteFailureState) {
                  AppDialog.showErrorDialog(context, state.msg);
                }
              },
              builder: (context, state) {
                if (state is ActionLoadingState ||
                    state is ActionDetailsDeleteSuccessState) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                }
                return SpecialIconCustomWidget(
                  icon: AssetConstant.trashIcon,
                  onTap: () => AppDialog.areYouSureDialog(
                    context,
                    "You About to delete this task",
                    BlocProvider.of<DetailsActionCubit>(context).onDelete,
                  ),
                );
              },
            ),
            SizedBox(width: 5),
            BlocConsumer<DetailsActionCubit, DetailsActionState>(
              listener: (context, state) {
                if (state is ActionDetailsSaveSuccessState) {
                  AppDialog.showSuccessDialog(context, "Success");
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.homeScreen,
                    (route) => false,
                  );
                }
                if (state is ActionDetailsSaveFailureState) {
                  AppDialog.showErrorDialog(context, state.msg);
                }
              },
              builder: (context, state) {
                if (state is ActionLoadingState ||
                    state is ActionDetailsSaveSuccessState) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                }
                return SpecialIconCustomWidget(
                  icon: AssetConstant.sendIcon,
                  onTap: () {
                    BlocProvider.of<DetailsActionCubit>(context).onSave();
                  },
                );
              },
            ),
            SizedBox(width: 15),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
            child: Column(
              spacing: 10,
              children: [
                TextFormFieldWithLabelCustomWidget(
                  validator: AppInputValidator.validateName,
                  labelText: "Task Name",
                  hintText: BlocProvider.of<DetailsActionCubit>(
                    context,
                  ).targetModel.name,
                  onChanged: BlocProvider.of<DetailsActionCubit>(
                    context,
                  ).updateTitle,
                ),
                SizedBox(height: 5),
                TextFormFieldWithLabelCustomWidget(
                  validator: AppInputValidator.validateName,
                  labelText: "Task Description",
                  hintText: BlocProvider.of<DetailsActionCubit>(
                    context,
                  ).targetModel.description,
                  onChanged: BlocProvider.of<DetailsActionCubit>(
                    context,
                  ).updateDesc,
                ),
                CustomCheckBox(
                  title: "Mark As Compeleted",
                  isCompleted:
                      BlocProvider.of<DetailsActionCubit>(
                        context,
                      ).targetModel.isCompleted ??
                      false,
                  onChange: BlocProvider.of<DetailsActionCubit>(
                    context,
                  ).setIsCompelete,
                ),
                BlocBuilder<DetailsActionCubit, DetailsActionState>(
                  buildWhen: (oldState, currentState) =>
                      currentState is ActionDetailsPickDateState,
                  builder: (context, state) {
                    final currentDate = BlocProvider.of<DetailsActionCubit>(
                      context,
                    ).getCurrentDate();
                    final sdate = DateTime.fromMillisecondsSinceEpoch(
                      BlocProvider.of<DetailsActionCubit>(context).currentDate,
                    );
                    return RowItemEditableCustomWidget(
                      title: "Task Date: ",
                      icon: AssetConstant.timerIcon,
                      value: currentDate,
                      onClick: () async {
                        final date = await showDatePickerDialog(
                          context: context,
                          selectedDate: sdate,
                          minDate: DateTime.now(),
                          maxDate: DateTime(2050),
                        );
                        if (context.mounted) {
                          BlocProvider.of<DetailsActionCubit>(
                            context,
                          ).updateDate(date);
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<DetailsActionCubit, DetailsActionState>(
                  buildWhen: (previous, current) =>
                      current is ActionDetailsPriorityState,
                  builder: (context, state) {
                    return RowItemEditableCustomWidget(
                      title: "Task Priority: ",
                      icon: AssetConstant.flagIcon,
                      value: BlocProvider.of<DetailsActionCubit>(
                        context,
                      ).getPriority().toString(),
                      onClick: () => showDialog(
                        context: context,
                        builder: (context) => PriorityAlertDialog(
                          limitPriority: 10,
                          taskPriority: BlocProvider.of<DetailsActionCubit>(
                            context,
                          ).getPriority(),
                          onPrioritySelected: (index) =>
                              BlocProvider.of<DetailsActionCubit>(
                                context,
                              ).updatePriority(index),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
