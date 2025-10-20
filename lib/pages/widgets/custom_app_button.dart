import 'package:flutter/material.dart';

class CustomAppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  const CustomAppButton({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xff008000),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
            )
        ),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18
          ),
        )
    );
  }
}
