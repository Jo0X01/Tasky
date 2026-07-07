import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/utils/app_dialog.dart';
import 'package:tasky/core/utils/app_input_validator.dart';
import 'package:tasky/core/widgets/text_form_field_with_label_custom_widget.dart';
import 'package:tasky/features/home/cubits/home_item_cubit/home_item_cubit.dart';
import 'package:tasky/features/home/cubits/logout_cubit/logout_cubit.dart';
import 'package:tasky/features/home/widgets/empty_items_custom_widget.dart';
import 'package:tasky/features/home/widgets/filter_item_custom_widget.dart';
import 'package:tasky/features/home/widgets/item_card_custom_widget.dart';
import 'package:tasky/features/home/widgets/show_bottom_add_task_details_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = AppRoutes.homeScreen;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<HomeItemCubit>(context).getAllTasks();
  }


  @override
  Widget build(BuildContext context) {
    final provider = BlocProvider.of<HomeItemCubit>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        actionsPadding: EdgeInsets.all(10),
        title: Image.asset(AssetConstant.logoImage),
        actions: [
          BlocListener<LogoutCubit, LogoutState>(
            listener: (context, state) {
              switch (state) {
                case LogoutInitial():
                  return;
                case LogoutLoadingState():
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Logging out....")));
                case LogoutSuccessState():
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(AppRoutes.splashScreen);
                case LogoutFailureState():
                  AppDialog.showErrorDialog(context, state.msg);
              }
            },
            child: GestureDetector(
              onTap: BlocProvider.of<LogoutCubit>(context).logout,
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
              validator: AppInputValidator.validateName,
              onChanged: provider.onSearch,
              hintText: "Search",
            ),
            Row(
              spacing: 10,
              children: [
                FilterItem(
                  title: "Compeleted",
                  onTap: (selected) => provider.setFilter(0, selected),
                ),
                FilterItem(
                  title: "Not Compeleted",
                  onTap: (selected) => provider.setFilter(1, selected),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<HomeItemCubit, HomeItemState>(
                builder: (context, state) {
                  if (state is HomeItemFailureState) {
                    return Center(
                      child: Text(
                        state.msg,
                        style: TextStyle(color: Colors.deepPurpleAccent),
                      ),
                    );
                  }
                  if (state is HomeItemSuccessState) {
                    return state.data.isEmpty
                        ? EmptyItemsCustomWidget()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.data.length,
                            itemBuilder: (context, index) =>
                                ItemCardCustomWidget(task: state.data[index]),
                          );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurpleAccent,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) =>
              ShowBottomAddTaskDetailsWidget(onSendPressed: provider.addTask),
        ),
        backgroundColor: Color(0xff24252C),
        shape: CircleBorder(),
        child: const Icon(Icons.add, size: 30, color: Color(0xff5F33E1)),
      ),
    );
  }
}
