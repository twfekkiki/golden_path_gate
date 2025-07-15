import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static  InputDecoration getInputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: Colors.black12,
              width: 0.8
          )
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: Colors.black12,
              width: 0.8
          )
      ),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: Colors.black12,
              width: 0.8
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: AppColors.primary,
              width: 0.8
          )
      ),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: Colors.red,
              width: 0.8
          )
      ),
    );
  }

}