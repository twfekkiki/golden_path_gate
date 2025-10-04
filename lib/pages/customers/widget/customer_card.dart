import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/models/customer.dart';

class CustomerCard extends StatefulWidget {
  final Customer customer;
  const CustomerCard({super.key, required this.customer});

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {

  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // onTap: (){
      //   context.go('/customer-list/details/${widget.customer.uid}');
      // },
      // onHover: (value){
      //   setState(() {
      //     hovered = value;
      //   });
      // },
      // borderRadius: BorderRadius.circular(kCornerRadius),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kCornerRadius),
          border: Border.all(
            color: hovered ?
            AppColors.secondary.withAlpha(150):
            Colors.grey.shade300,
            width: 0.7,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // runSpacing: 12,
          children: [
            Text(
              "${widget.customer.firstName} ${widget.customer.lastName}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              widget.customer.phone,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
            if(widget.customer.email != null)
              Text(
                widget.customer.email!,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
