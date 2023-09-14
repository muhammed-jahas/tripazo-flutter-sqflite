import 'package:flutter/material.dart';
import 'package:tripazo/styles/color_styles.dart';

//Custom Primary Button
class CustomPrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  CustomPrimaryButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF974C),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

//Custom Secondary Button
class CustomSecondaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  CustomSecondaryButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

//Custom Alert  Button
class CustomAlertButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  CustomAlertButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.alertColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

//Custom Span Text with Navigation
class CustomSpanText extends StatelessWidget {
  final String mainText;
  final String spanText;
  final String routeName;
  CustomSpanText({
    required this.mainText,
    required this.spanText,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          mainText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Color(0xFF888888),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, routeName);
          },
          child: Text(
            spanText,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

//Custom Icon Button
class CustomIconButton extends StatelessWidget {
  final IconData ButtonIcon;
  final VoidCallback onPressed;

  CustomIconButton({
    super.key,
    required this.ButtonIcon,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black,
      ),
      child: IconButton(
        icon: Icon(
          ButtonIcon,
          size: 16,
          color: Colors.white,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
