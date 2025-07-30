import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';

class PODDialog extends StatelessWidget {
  const PODDialog({super.key});


  static show(BuildContext context){
    return showDialog(context: context, builder: (context){
      return PODDialog();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCornerRadius),
      ),
      elevation: 0.8,
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: 400
              ),
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(kCornerRadius)
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context).trans("uploadPOD"),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    color: Colors.black54
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8,),
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  // context.go('/shipment-list/details/ABC537764233');
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
                  AppLocalizations.of(context).trans("submit"),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
