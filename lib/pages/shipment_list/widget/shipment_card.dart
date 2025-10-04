import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/services/app_info_service.dart';

class ShipmentCard extends StatefulWidget {
  final Shipment? shipment;
  const ShipmentCard({super.key, required this.shipment});

  @override
  State<ShipmentCard> createState() => _ShipmentCardState();
}

class _ShipmentCardState extends State<ShipmentCard> {
  bool hovered = false;


  final AppInfoService _appInfoService = AppInfoService();
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
                CardItem(title: AppLocalizations.of(context).trans("shipmentNumber"), value: widget.shipment!.shipmentNumber,),
                CardItem(title: AppLocalizations.of(context).trans("customerName"), value: widget.shipment!.customerName,),
                CardItem(
                  title: AppLocalizations.of(context).trans('shipmentStatus'),
                  value: _appInfoService.getStatusName(
                    widget.shipment!.status,
                    pickUpDate: widget.shipment!.pickupDate,
                    origin: widget.shipment!.origin,
                    destinationPort: widget.shipment!.destinationPort,
                    hub: widget.shipment!.hub
                  ).toUpperCase(),
                ),
                CardItem(title: AppLocalizations.of(context).trans('createdAt'), value: widget.shipment!.formatedDatetime,),
                CardItem(title: AppLocalizations.of(context).trans('modifiedAt'), value: '25/6/2025',),
                CardItem(title: AppLocalizations.of(context).trans('shipmentTransport'), value: widget.shipment!.shipmentTransportType,),
              ],
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            end: 0,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(kCornerRadius)
                  ),
                  color: Colors.blue
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8
              ),
              child: Text(
                _appInfoService.getStatusName(widget.shipment!.status).toUpperCase(),
                // AppLocalizations.of(context).trans(widget.shipment!.status.name).toUpperCase(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
          ),
          if(hovered)
            PositionedDirectional(
              top: 4,
              end: 4,
              child: ElevatedButton(
                  onPressed: (){
                    context.go('/shipment-list/details/${widget.shipment!.uid}');
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
                    AppLocalizations.of(context).trans("details"),
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
                      // color: Colors.black
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
                      // color: Colors.black54
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}

