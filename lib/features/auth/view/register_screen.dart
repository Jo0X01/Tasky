import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/utils/app_dialog.dart';
import 'package:tasky/core/utils/app_input_validator.dart';
import 'package:tasky/core/widgets/text_form_field_with_label_custom_widget.dart'
    show TextFormFieldWithLabelCustomWidget;
import 'package:tasky/features/auth/cubits/auth_cubit/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String routeName = "RegisterScreen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var usernameController = TextEditingController();
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
              SizedBox(height: 97),
              Text(
                "Register",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff24252C),
                ),
              ),
              SizedBox(height: 23),
              TextFormFieldWithLabelCustomWidget(
                controller: usernameController,
                validator: AppInputValidator.validateName,
                labelText: "Username",
                hintText: "enter username",
              ),
              SizedBox(height: 11),
              TextFormFieldWithLabelCustomWidget(
                controller: emailController,
                validator: AppInputValidator.validateEmail,
                labelText: "Email",
                hintText: "enter username",
              ),
              SizedBox(height: 11),
              TextFormFieldWithLabelCustomWidget(
                controller: passwordController,
                validator: AppInputValidator.validatePassword,
                labelText: "Password",
                hintText: "Password...",
                isPassword: true,
                obscureText: true,
              ),
              SizedBox(height: 11),
              TextFormFieldWithLabelCustomWidget(
                controller: confirmPasswordController,
                validator: (text) => AppInputValidator.validateConfirmPassword(
                  text,
                  passwordController.text,
                ),
                labelText: "Confirm Password",
                hintText: "Password...",
                isPassword: true,
                obscureText: true,
              ),
              SizedBox(height: 75),
              MaterialButton(
                onPressed: () {
                  if (loginFormKey.currentState!.validate()) {
                    BlocProvider.of<AuthCubit>(context).register(
                      email: emailController.text,
                      password: passwordController.text,
                      username: usernameController.text,
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
                    } else if (state is AuthRegisterFailureState) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      AppDialog.showErrorDialog(context, state.msg);
                    } else if (state is AuthRegisterSuccessState) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      emailController.clear();
                      passwordController.clear();
                      confirmPasswordController.clear();
                      usernameController.clear();
                      AppDialog.showSuccessDialog(
                        context,
                        "Registration successful",
                        onDismiss: () => Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.loginScreen),
                      );
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
                      "Register",
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
            Navigator.of(context).pop();
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
                TextSpan(text: "Already have an account? "),
                TextSpan(
                  text: "Login",
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
    confirmPasswordController.dispose();
    usernameController.dispose();
  }
}
