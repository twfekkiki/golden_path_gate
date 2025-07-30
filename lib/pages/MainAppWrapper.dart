// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
// import 'package:golden_path_gate_admin_portal/pages/create_shipment/create_shipment.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/drawer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/header.dart';

// import 'customers/create_customer.dart';
// import 'customers/customer_list.dart';
// import 'shipment_list/shipment_list.dart';

class MainAppWrapper extends StatefulWidget {
  final String path;
  final Widget child;

  const MainAppWrapper({super.key, required this.child, required this.path});

  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> {

  bool drawer = true;
  int selectedPage = 0;


  // late List<Widget> pages;

  @override
  void initState() {
    // pages = [
    //   ShipmentFormPage(),
    //   ShipmentList(),
    //   CustomerList(),
    //   CreateCustomerFormPage()
    // ];
    super.initState();
  }


  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context,constrains){
          bool isMobile = constrains.maxWidth < kSmallSize;
          return Scaffold(
            key: _key,
            backgroundColor:
            Theme.of(context).brightness == Brightness.dark?
            Colors.black: Colors.grey.shade200,
            drawer: isMobile ?
            AppDrawer(opened: true,isSide: true, onChange: (value ) {
              _key.currentState!.closeDrawer();
            }, selectedIndex: _getSelectedPage,) : null,
            drawerEnableOpenDragGesture: false,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  AppDrawer(
                    opened: drawer,
                    selectedIndex: _getSelectedPage,
                    onChange: (index){
                      _key.currentState!.closeDrawer();
                    },
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                      child: Column(
                        children: [
                          Header(
                            callback: (value){
                              if(isMobile){
                                if(drawer){
                                  _key.currentState!.openDrawer();
                                }
                                else {
                                  _key.currentState!.closeDrawer();
                                }

                              }
                              setState(() {
                                drawer = value;
                              });

                            },
                            isMobile: isMobile,
                          ),
                          const SizedBox(height: 16,),
                          Expanded(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(kCornerRadius),
                                  child: widget.child
                                  // pages[selectedPage],//ShipmentFormPage()
                              )
                          ),
                        ],
                      )
                  ),
                ],
              ),
            )
          );
        });
  }

  int get _getSelectedPage {
    print("_getSelectedPage");
    String basePage = widget.path.split('/')[1];
    print(basePage);
    if(basePage == 'create-shipment'){
      return 0;
    }
    if(basePage == 'shipment-list'){
      return 1;
    }
    if(basePage == 'customer-list'){
      return 2;
    }
    if(basePage == 'settings'){
      return 3;
    }
    if(basePage == 'user-list'){
      return 4;
    }
    return 0;
  }
}
