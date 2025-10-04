import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';

class FormInputContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isMainTitle;

  const FormInputContainer({
    super.key,
    required this.title,
    required this.child,
    this.isMainTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isMainTitle ? 18 : 14,
            color:
                Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).primaryColor
                    : Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
