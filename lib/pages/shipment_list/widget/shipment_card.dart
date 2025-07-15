import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';

class ShipmentCard extends StatefulWidget {
  final Shipment? shipment;
  const ShipmentCard({super.key, required this.shipment});

  @override
  State<ShipmentCard> createState() => _ShipmentCardState();
}

class _ShipmentCardState extends State<ShipmentCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value){
        setState(() {
          hovered = true;
        });
      },
      onExit: (value){
        setState(() {
          hovered = false;
        });
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kCornerRadius),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 0.7,
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Wrap(
              runSpacing: 12,
              children: [
                CardItem(title: 'Shipment Number', value: widget.shipment!.shipmentNumber,),
                CardItem(title: 'Customer Name', value: widget.shipment!.customerName,),
                CardItem(title: 'Shipment Status', value: widget.shipment!.status.name.toUpperCase(),),
                CardItem(title: 'Created at', value: widget.shipment!.formatedDatetime,),
                CardItem(title: 'Modified at', value: '25/6/2025',),
                CardItem(title: 'Shipment Transport', value: widget.shipment!.shipmentTransportType,),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(kCornerRadius)
                  ),
                  color: Colors.blue
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8
              ),
              child: Text(
                widget.shipment!.status.name.toUpperCase(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
          ),
          if(hovered)
            Positioned(
              bottom: 4,
              right: 4,
              child: ElevatedButton(
                  onPressed: (){
                    context.go('/shipments-list/details/${widget.shipment!.uid}');
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff008000),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  child: Text(
                    "Details",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18
                    ),
                  )
              ),
            ),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final String value;
  const CardItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context,constrains) {
          double width = (constrains.maxWidth) / 4;
          if(constrains.maxWidth < kMidSize){
            width = (constrains.maxWidth) / 2;
          }
          return SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black
                  ),
                ),
                const SizedBox(height: 8,),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.black54
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}

