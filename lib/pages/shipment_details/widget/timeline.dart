import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/shipment_details_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/widget/timeline_provider.dart';
import 'package:golden_path_gate_admin_portal/services/app_info_service.dart';
import 'package:golden_path_gate_admin_portal/services/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

import 'add_new_stage.dart';

class ProcessTimelineWidget extends StatefulWidget {
  final String uid;
  final String customerId;
  //final List<ShipmentStatusHistory> statusHistory;

  const ProcessTimelineWidget({super.key, required this.uid, required this.customerId});

  @override
  ProcessTimelineWidgetState createState() => ProcessTimelineWidgetState();
}

class ProcessTimelineWidgetState extends State<ProcessTimelineWidget> {

  late TimelineProvider timelineProvider;

  final AppInfoService _appInfoService = AppInfoService();

  @override
  void initState() {
    // _processIndex = widget.statusHistory.length - 1;
    timelineProvider = TimelineProvider(widget.uid,widget.customerId);
    timelineProvider.getTimeline();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimelineProvider>.value(
      value: timelineProvider,
      child: Consumer<TimelineProvider>(
        builder: (context,snapshot,child) {
          if(snapshot.statusHistory == null){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<ShipmentStatusHistory> statusHistory = snapshot.statusHistory!;
          int _processIndex = statusHistory.length - 1;

          return Column(
            crossAxisAlignment:  CrossAxisAlignment.start,
            children: [
              Timeline.tileBuilder(
                shrinkWrap: true,
                theme: TimelineThemeData(
                  nodePosition: 0,
                  nodeItemOverlap: true,
                  connectorTheme: const ConnectorThemeData(
                    color: Color(0xffe6e7e9),
                    thickness: 15.0,
                  ),
                ),
                padding: const EdgeInsets.only(top: 20.0),
                builder: TimelineTileBuilder.connected(
                  indicatorBuilder: (context, index) {
                    return OutlinedDotIndicator(
                      color: index <= _processIndex
                          ? const Color(0xff6ad192)
                          : const Color(0xffe6e7e9),
                      backgroundColor: index <= _processIndex
                          ? const Color(0xffd4f5d6)
                          : const Color(0xffc2c5c9),
                      borderWidth: index <= _processIndex ? 3.0 : 2.5,
                    );
                  },
                  connectorBuilder: (context, index, connectorType) {
                    Color? color;
                    if (index <= _processIndex) {
                      color = const Color(0xff6ad192) ;
                    }
                    return SolidLineConnector(
                      color: color,
                    );
                  },
                  contentsBuilder: (context, index) {
                   return Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           _appInfoService.getStatusName(_appInfoService.status![index].index),
                           // AppLocalizations.of(context).trans(ShipmentStatus.values[index].name).toUpperCase(),
                           style: TextStyle(
                             fontSize: 16,
                             color: index < _processIndex ?
                             AppColors.primary :
                             index == _processIndex ? AppColors.secondary: Colors.black45,
                             fontWeight: FontWeight.bold
                           ),
                         ),
                         if(index <= _processIndex)
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 index == statusHistory.length ? '' :
                                 statusHistory[index].formatedCreatedAt,
                                 style: TextStyle(
                                     fontSize: 10,
                                     color: Colors.black45,
                                     fontWeight: FontWeight.bold
                                 ),
                               ),
                               const SizedBox(height: 4,),
                               Text(
                                 index == statusHistory.length ? '' :
                                 statusHistory[index].note,
                                 style: TextStyle(
                                     fontSize: 12,
                                     color: Colors.black87,
                                     fontWeight: FontWeight.normal,
                                     height: 1.2
                                 ),
                                 textAlign: TextAlign.justify,
                               )
                             ],
                           )
                       ],
                     ),
                   );
                  },
                  itemCount: statusHistory.length < _appInfoService.status!.length ? statusHistory.length  + 1  : statusHistory.length,
                ),
              ),
              const SizedBox(height: 8,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        ShipmentsDetailsProvider shipmentsDetailsProvider = Provider.of<ShipmentsDetailsProvider>(context,listen: false);
                        var result = await AddNewStageDialog.show(context,snapshot.statusHistory!.last.status);
                        if(result != null){
                          await timelineProvider.changeStatus(result,shipmentsDetailsProvider.shipment!);
                          if(timelineProvider.done){
                            await shipmentsDetailsProvider.getShipmentsDetails();
                            timelineProvider.reset();
                            timelineProvider.getTimeline();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xff008000),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          )
                      ),
                      child: snapshot.loading ?
                      SpinKitThreeBounce(
                        size: 20,
                        color: Colors.white,
                      ) : Text(
                        AppLocalizations.of(context).trans("updateStage"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18
                        ),
                      )
                  ),
                ],
              )
            ],
          );
        }
      ),
    );
  }
}


