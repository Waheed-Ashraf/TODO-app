import 'package:farmedia/features/auth/domain/entites/user_entity.dart';
import 'package:farmedia/features/auth/presentation/views/complete_profile_view.dart';
import 'package:farmedia/features/home/presentation/views/widgets/sell_products_view_body.dart';
import 'package:flutter/material.dart';
import 'package:farmedia/features/auth/presentation/views/signin_view.dart';
import 'package:farmedia/features/auth/presentation/views/signup_view.dart';
import 'package:farmedia/features/best_selling_fruits/presentation/views/best_selling_view.dart';
import 'package:farmedia/features/home/domain/entites/cart_entity.dart';
import 'package:farmedia/features/home/presentation/views/main_view.dart';
import 'package:farmedia/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:farmedia/features/splash/presentation/views/splash_view.dart';

import '../../features/checkout/presentation/views/checkout_view.dart';
import '../../features/home/domain/entites/car_item_entity.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context) => const SplashView());
    case CheckoutView.routeName:
      return MaterialPageRoute(
        builder:
            (context) =>
                CheckoutView(cartEntity: settings.arguments as CartEntity),
      );
    case BestSellingView.routeName:
      return MaterialPageRoute(builder: (context) => const BestSellingView());
    case SigninView.routeName:
      return MaterialPageRoute(builder: (context) => const SigninView());
    case CompleteProfileView.routeName:
      return MaterialPageRoute(
        builder:
            (context) => CompleteProfileView(
              userEntity: settings.arguments as UserEntity,
            ),
      );
    case SignupView.routeName:
      return MaterialPageRoute(builder: (context) => const SignupView());
    case MySellRequestsView.routeName:
      return MaterialPageRoute(
        builder: (context) => const MySellRequestsView(),
      );
    case MainView.routeName:
      return MaterialPageRoute(builder: (context) => const MainView());
    case OnBoardingView.routeName:
      return MaterialPageRoute(builder: (context) => const OnBoardingView());
    default:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
}
