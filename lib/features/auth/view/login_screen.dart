import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/utils/app_dialog.dart';
import 'package:tasky/core/utils/app_input_validator.dart';
import 'package:tasky/core/widgets/text_form_field_with_label_custom_widget.dart';
import 'package:tasky/features/auth/cubits/auth_cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = AppRoutes.loginScreen;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 122),
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff24252C),
                ),
              ),
              SizedBox(height: 53),
              TextFormFieldWithLabelCustomWidget(
                controller: emailController,
                validator: AppInputValidator.validateEmail,
                labelText: "Email",
                hintText: "enter username",
              ),
              SizedBox(height: 26),
              TextFormFieldWithLabelCustomWidget(
                controller: passwordController,
                validator: AppInputValidator.validatePassword,
                labelText: "Password",
                hintText: "Password...",
                isPassword: true,
                obscureText: true,
              ),
              SizedBox(height: 71),
              MaterialButton(
                onPressed: () {
                  if (loginFormKey.currentState!.validate()) {
                    BlocProvider.of<AuthCubit>(context).login(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  }
                },
                height: 48,
                color: Color(0xff5F33E1),
                textColor: Color(0xffffffff),
                minWidth: double.infinity,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthRegisterLoadingState) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Connecting....')));
                    } else if (state is AuthLoginFailureState) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      AppDialog.showErrorDialog(context, 'Error: ${state.msg}');
                    } else if (state is AuthLoginSuccessState) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Welcome Back <3')),
                      );
                      emailController.clear();
                      passwordController.clear();
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(AppRoutes.homeScreen);
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoginLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      );
                    }
                    return Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffffffff),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.registerScreen);
          },
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xff6E6A7C),
              ),
              children: [
                TextSpan(text: "Don’t have an account? "),
                TextSpan(
                  text: "Register",
                  style: TextStyle(color: Color(0xff5F33E1)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
