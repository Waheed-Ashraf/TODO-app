import 'package:flutter/material.dart';
import 'package:todo_app_task/core/utils/app_colors.dart';
import 'package:todo_app_task/core/widgets/notification_widget.dart';

import '../utils/app_text_styles.dart';

AppBar buildAppBar(
  context, {
  required String title,
  bool showBackButton = true,
  bool showNotification = true,
  bool showButton = true,
  String? buttonText,
  void Function()? onPressed,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    actions: [
      Visibility(
        visible: showNotification,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: NotificationWidget(),
        ),
      ),
      Visibility(
        visible: showButton,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () {
              onPressed?.call();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  buttonText ?? "طلبات البيع",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
    leading: Visibility(
      visible: showBackButton,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios_new),
      ),
    ),
    centerTitle: true,
    title: Text(title, textAlign: TextAlign.center, style: TextStyles.bold19),
  );
}
