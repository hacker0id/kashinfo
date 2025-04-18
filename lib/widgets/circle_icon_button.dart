import 'package:flutter/material.dart';
import 'package:kashinfo/constants/app_colors.dart';

class CircleButton extends StatefulWidget {
  final String text;
  final IconData iconData;
  final VoidCallback onTap;

  const CircleButton({
    Key? key,
    required this.text,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  _CircleButtonState createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  // Variable to track the tap state for scaling effect
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (isHighlighted) {
            setState(() {
              _isTapped = isHighlighted;
            });
          },
          splashColor: Colors.transparent, // No splash effect
          highlightColor: Colors.transparent, // No highlight color
          child: AnimatedScale(
            scale: _isTapped ? 0.85 : 1.0, // Scale effect on tap
            duration: Duration(milliseconds: 150), // Duration of scaling effect
            child: Container(
              width: 60, // Equivalent to radius 30 * 2
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: _isTapped // Add a shadow when tapped
                    ? [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2), blurRadius: 4)
                      ]
                    : [],
              ),
              child: Center(
                child: Container(
                  width: 54, // Equivalent to radius 27 * 2
                  height: 54,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      widget.iconData,
                      size: 25,
                      color: AppColors.pink,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
        Text(
          widget.text,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              letterSpacing: 0,
              color: Colors.white),
        ),
      ],
    );
  }
}
