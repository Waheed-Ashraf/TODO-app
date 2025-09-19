import 'package:flutter/material.dart';

import 'package:svg_flutter/svg.dart';
import 'package:todo_app_task/core/utils/app_images.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/main_dashboard_view.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    excuteNaviagtion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [SvgPicture.asset(Assets.imagesPlant)],
        ),
        SvgPicture.asset(Assets.imagesLogo),
        SvgPicture.asset(Assets.imagesSplashBottom, fit: BoxFit.fill),
      ],
    );
  }

  void excuteNaviagtion() {
    //   bool isOnBoardingViewSeen = Prefs.getBool(kIsOnBoardingViewSeen);
    Future.delayed(const Duration(seconds: 3), () {
      // if (isOnBoardingViewSeen) {
      //   var isLoggedIn = FirebaseAuthService().isLoggedIn();

      //   if (isLoggedIn) {
      //     Navigator.pushReplacementNamed(context, MainView.routeName);
      //   } else {
      //     Navigator.pushReplacementNamed(context, SigninView.routeName);
      //   }
      // } else {
      //   Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
      // }

      Navigator.pushReplacementNamed(context, MainDashboardView.routeName);
    });
  }
}
