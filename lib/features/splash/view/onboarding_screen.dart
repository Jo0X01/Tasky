import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/features/splash/data/models/onboarding_model.dart';
import 'package:tasky/features/splash/widgets/custom_animation_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  static const String routeName = AppRoutes.onBoardingScreen;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int targetIndex = 0;
  int delay = 20;
  PageController builderController = PageController();
  late List<OnboardingModel> onboardData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onboardData =
        ModalRoute.of(context)!.settings.arguments as List<OnboardingModel>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 143),
            SizedBox(
              height: 240,
              child: PageView.builder(
                itemCount: onboardData.length,
                controller: builderController,
                onPageChanged: (value) => setState(() => targetIndex = value),
                itemBuilder: (context, index) {
                  return CustomAnimationWidget(
                    index: targetIndex,
                    delay: (targetIndex + 1) * delay,
                    child: Image.memory(
                      onboardData[index].imageConvertFromBase64()!,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 29),
            CustomAnimationWidget(
              index: targetIndex,
              delay: (targetIndex + 1) * delay,
              child: SmoothPageIndicator(
                controller: builderController,
                count: onboardData.length,
                effect: SlideEffect(
                  spacing: 8,
                  dotHeight: 4,
                  dotWidth: 26,
                  dotColor: Color(0xFFAFAFAF),
                  activeDotColor: Color(0xDE5F33E1),
                ),
              ),
            ),
            SizedBox(height: 50),
            CustomAnimationWidget(
              index: targetIndex,
              delay: (targetIndex + 1) * delay,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                child: Column(
                  spacing: 42,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentBoard.title!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xDE24252C),
                      ),
                    ),
                    Text(
                      currentBoard.desc!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xDE6E6A7C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MaterialButton(
        disabledColor: Colors.transparent,
        onPressed: _onNextPressed,
        height: 48,
        color: Color(0xff5F33E1),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        child: Text(
          targetIndex == onboardData.length - 1 ? "GET STARTED" : "NEXT",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xffffffff),
          ),
        ),
      ),
    );
  }

  OnboardingModel get currentBoard => onboardData[targetIndex];

  void _onNextPressed() {
    if (targetIndex < onboardData.length - 1) {
      builderController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
      targetIndex += 1;
      setState(() {});
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen);
    }
  }
}
