import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kashinfo/constants/app_colors.dart';

class Button extends StatefulWidget {
  Button(
      {super.key,
      required this.onPressed,
      required this.text,
      this.width,
      this.showIcon = true});
  final VoidCallback onPressed;
  final String text;
  bool? showIcon;
  double? width;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  // Track the scale state for animated scaling effect
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      elevation: 10,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.055,
        width: widget.width == null
            ? widget.text == 'Next'
                ? MediaQuery.sizeOf(context).width * 0.35
                : MediaQuery.sizeOf(context).width * 0.55
            : widget.width!,
        child: InkWell(
          onTap: () {
            setState(() {
              _isTapped = true;
            });
            // Call the onPressed callback after a small delay to allow animation
            Future.delayed(Duration(milliseconds: 100), () {
              widget.onPressed();
            });
          },
          onHighlightChanged: (isHighlighted) {
            setState(() {
              _isTapped = isHighlighted;
            });
          },
          splashColor: Colors.transparent, // No splash effect
          highlightColor: Colors.transparent, // No highlight color
          child: AnimatedScale(
            scale: _isTapped ? 0.95 : 1.0, // Scale effect on tap
            duration: Duration(milliseconds: 150), // Duration of scaling effect
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                  enableFeedback: true,
                  foregroundColor: AppColors.pink),
              onPressed: widget.onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(fontSize: 16.5),
                  ),
                  widget.text != 'Next'
                      ? SizedBox(width: MediaQuery.sizeOf(context).width * 0.05)
                      : SizedBox.shrink(),
                  if (widget.showIcon!)
                    widget.text != 'Next'
                        ? Icon(
                            CupertinoIcons.arrow_right_circle_fill,
                            color: AppColors.pink,
                            size: 32,
                          )
                        : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
