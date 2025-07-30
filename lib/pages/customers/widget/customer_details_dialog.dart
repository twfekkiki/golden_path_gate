import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/customer.dart';

class CustomerDetailsDialog extends StatefulWidget {

  final Customer customer;

  const CustomerDetailsDialog({super.key, required this.customer});

  @override
  State<CustomerDetailsDialog> createState() => _CustomerDetailsDialogState();
}

class _CustomerDetailsDialogState extends State<CustomerDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCornerRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context).trans("customer"),
              style: Theme.of(context).textTheme.titleMedium
            ),
          ),
          Divider(
            height: 18,
            thickness: 0.8,
            color: Theme.of(context).dividerColor.withAlpha(100),
          ),
          Row(
            children: [

            ],
          )
        ],
      ),
    );
  }
}
