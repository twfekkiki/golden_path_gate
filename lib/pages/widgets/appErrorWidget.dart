import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';

class ErrorAppWidget extends StatelessWidget {
  final dynamic error;
  const ErrorAppWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(kCornerRadius),
            border: Border.all(
                color: Colors.black
            )
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(
            vertical: 12
        ),
        child: Text(
          error.toString(),
          // 'error with the error in the error but erroring the error need more errors to error the thing out of the error zone!',
          // snapshot.error.toString(),
          style: TextStyle(
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}
