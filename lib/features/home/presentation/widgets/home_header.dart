import 'package:flutter/material.dart';
import 'package:motivation_app/core/widgets/app_logo.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: AppLogo(fontSize: 16),
    );
  }
}
