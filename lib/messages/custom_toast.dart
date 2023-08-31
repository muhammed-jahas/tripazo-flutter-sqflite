import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final IconData toastIcon;
  final Color toastBackground;
  final double? heightposition;

  CustomToast({
    required this.message,
    required this.toastIcon,
    required this.toastBackground,
    this.heightposition,
  });
  @override
  Widget build(BuildContext context) {
    double defaultHeight = 100.0;
    double actualHeight = heightposition ?? defaultHeight;
    return Positioned(
      bottom: actualHeight,
      left: 0,
      right: 0,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 2000),
        curve: Curves.fastEaseInToSlowEaseOut,
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: toastBackground,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(toastIcon, color: Colors.white),
                    SizedBox(width: 15),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        decoration: TextDecoration.none,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

showCustomToast(BuildContext context, String message, IconData toastIcon,
    Color toastBackground,
    {double? height}) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => CustomToast(
      message: message,
      toastIcon: toastIcon,
      toastBackground: toastBackground,
      heightposition: height,
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  // Wait for a few seconds and then remove the toast
  Future.delayed(Duration(seconds: 3)).then((_) {
    overlayEntry.remove();
  });
}
