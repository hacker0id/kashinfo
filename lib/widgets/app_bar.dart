import 'package:flutter/material.dart';
import 'package:kashinfo/constants/app_colors.dart';
import 'package:kashinfo/modules/onboarding/onboarding.dart';

class GradientAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const GradientAppBar({super.key, required this.title, this.actions});

  @override
  _GradientAppBarState createState() => _GradientAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(deviceHeight! * 0.15); // Default height
}

class _GradientAppBarState extends State<GradientAppBar> {
  double? dynamicHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dynamicHeight = MediaQuery.of(context).size.height *
        0.35; // Adjust based on screen height
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dynamicHeight,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.orange, AppColors.pink],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
      ),
    );
  }
}
