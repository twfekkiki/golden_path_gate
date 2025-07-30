import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';


class FormWidgetContainer extends StatelessWidget {
  final Widget child;
  const FormWidgetContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCornerRadius),
        border: _getBorder(context),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(
        bottom: 12
      ),
      child: child,
    );
  }

  _getBorder(BuildContext context) {
    return Border.all(
      color:
      Theme.of(context).brightness == Brightness.light ?
          Colors.black12 : Colors.white24,
      width: 0.7,
    );
  }
}
