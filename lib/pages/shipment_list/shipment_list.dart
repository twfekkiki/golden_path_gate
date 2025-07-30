import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_list/shipmentsListProvider.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_list/widget/filter_shipments.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_list/widget/shipment_card.dart';
import 'package:provider/provider.dart';

class ShipmentList extends StatefulWidget {
  const ShipmentList({super.key});

  @override
  State<ShipmentList> createState() => _ShipmentListState();
}

class _ShipmentListState extends State<ShipmentList> {

  bool _showFilter = false;

  final ShipmentsListProvider shipmentsListProvider = ShipmentsListProvider();

  @override
  void initState() {
    shipmentsListProvider.getShipmentsList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShipmentsListProvider>.value(
      value: shipmentsListProvider,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).trans("shipmentsList"),
                        style: TextStyle(
                            fontSize: 32,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle
                        ),
                        child: IconButton(
                          onPressed: (){
                            setState(() {
                              _showFilter = !_showFilter;
                            });
                          },
                          icon: Icon(
                            Icons.filter_alt_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                  if(_showFilter)
                    Padding(
                    padding: const EdgeInsets.only(
                        top: 12
                    ),
                    child: Row(
                      children: [
                        Expanded(child: FilterShipments()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16,),
            Expanded(
              child: Consumer<ShipmentsListProvider>(
                builder: (context,snapshot,child) {
                  if(snapshot.shipments == null){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<Shipment> shipments = snapshot.shipments??[];

                  return ListView.separated(
                    padding: EdgeInsets.all(16),
                      itemBuilder: (context,index){
                        return ShipmentCard(shipment: shipments[index],);
                      },
                      separatorBuilder: (context,index){
                        return const SizedBox(height: 12,);
                      },
                      itemCount: shipments.length
                  );
                }
              ),
            ),
          ],
        )
      ),
    );
  }
}
