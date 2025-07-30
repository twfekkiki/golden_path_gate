import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/services/app_config_service.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).trans("settings"),
              style: TextStyle(
                  fontSize: 32,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold
              ),
            ),
            ListTile(
              leading: Icon(Icons.language,size: 25,),
              title: Text(
                AppLocalizations.of(context).trans("language"),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              trailing: Icon(Icons.arrow_drop_down_outlined,size: 15,),
              onTap: () async {
                var result = await LanguageChangeDialog.show(context);
                if(result != null){
                  Provider.of<AppConfigService>(context,listen: false).lang = result;
                }
              },
            ),
            const SizedBox(height: 8,),
            ListTile(
              leading: Icon(Icons.sunny,size: 25,),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kCornerRadius)
              ),

              title: Text(
                AppLocalizations.of(context).trans("brightness"),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              trailing: Icon(Icons.arrow_drop_down_outlined,size: 15,),
              onTap: () async {
                var result = await BrightnessChangeDialog.show(context);
                if(result != null){
                  Provider.of<AppConfigService>(context,listen: false).brightness = result;
                }
              },
            ),
            const SizedBox(height: 8,),
            /*ListTile(
              leading: Icon(Icons.phone,size: 25,),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kCornerRadius)
              ),

              title: Text(
                AppLocalizations.of(context).trans("contactUs"),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              trailing: Icon(Icons.arrow_drop_down_outlined,size: 15,),
              onTap: () async {
                var result = await BrightnessChangeDialog.show(context);
                if(result != null){
                  Provider.of<AppConfigService>(context,listen: false).brightness = result;
                }
              },
            ),
            const SizedBox(height: 8,),

            Expanded(child: const SizedBox()),
            Column(
              children: [
                Text(
                  AppLocalizations.of(context).trans("appVersion"),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 8,),
                Text(
                  "1.0.0",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 16,),
              ],
            )
            */
          ],
        ),
      ),
    );
  }
}


class LanguageChangeDialog extends StatelessWidget {

  static show(BuildContext context){
    return showDialog(context: context, builder: (context) => LanguageChangeDialog());
  }

  const LanguageChangeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCornerRadius),
      ),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(kCornerRadius),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 16
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for(String lang in AppLang.values)
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pop(lang);
                        },
                        borderRadius: BorderRadius.circular(kCornerRadius),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16
                          ),
                          child: Text(
                            AppLocalizations.of(context).trans(lang),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      )
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}

class BrightnessChangeDialog extends StatelessWidget {

  static show(BuildContext context){
    return showDialog(context: context, builder: (context) => BrightnessChangeDialog());
  }

  const BrightnessChangeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCornerRadius),
      ),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(kCornerRadius),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 16
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for(Brightness brightness in Brightness.values)
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pop(brightness);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16
                          ),
                          child: Text(
                            AppLocalizations.of(context).trans(brightness.name),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      )
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}

