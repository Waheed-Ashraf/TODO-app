import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app_task/core/utils/app_images.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/main_dashboard_view.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goNext();
      }
    });
  }

  void _goNext() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, MainDashboardView.routeName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        Assets.imagesSplashAnimation,
        controller: _controller,
        fit: BoxFit.contain,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward();
        },
      ),
    );
  }
}
