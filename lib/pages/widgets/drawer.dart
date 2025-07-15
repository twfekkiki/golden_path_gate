import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';

class AppDrawer extends StatefulWidget {
  final bool opened;
  final Function(int) onChange;
  final int selectedIndex;
  final bool isSide;
  const AppDrawer({super.key, required this.opened, required this.onChange, required this.selectedIndex,this.isSide = false});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  @override
  Widget build(BuildContext context) {
    bool isSmall = MediaQuery.of(context).size.width < kSmallSize;

    if(isSmall && !widget.isSide) return const SizedBox();
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child,animation){
        return SizeTransition(
          sizeFactor: animation, axis: Axis.horizontal, child: child
        );
      },
      child: ((widget.opened && !isSmall) || widget.isSide) ?
      Container(
        key: ValueKey('DrawerOpened'),
        width: 300,
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(kCornerRadius),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 1
              )
            ]
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(kCornerRadius),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 1
                      )
                    ]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kCornerRadius),
                  child: Center(
                    child: Image.asset( "assets/icons/icon3.png",
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            DrawerItem(
              iconData: Icons.local_shipping_outlined,
              title: 'Create Shipment',
              selected: widget.selectedIndex == 0,
              onCLick: () {
                // setState(() {
                //   selectedPage = 0;
                // });
                print("Hello");
                widget.onChange(0);
                GoRouter.of(context).go('/create-shipment');

              },
            ),
            const SizedBox(height: 12,),
            DrawerItem(
              iconData: Icons.list_alt,
              title: 'Shipments List',
              selected: widget.selectedIndex == 1,
              onCLick: () {
                // setState(() {
                //   selectedPage = 1;
                // });
                GoRouter.of(context).go('/shipments-list');
                widget.onChange(1);
              },
            ),
            const SizedBox(height: 12,),
            DrawerItem(
              iconData: Icons.people_outline,
              title: 'Customers List',
              selected: widget.selectedIndex == 2,
              onCLick: () {
                // setState(() {
                //   selectedPage = 2;
                // });
                GoRouter.of(context).go('/customers-list');
                widget.onChange(2);
              },
            ),
            const SizedBox(height: 12,),
            DrawerItem(
              iconData: Icons.settings,
              title: 'Settings',
              selected: widget.selectedIndex == 3,
              onCLick: () {
                // setState(() {
                //   selectedPage = 3;
                // });
                //GoRouter.of(context).push('shipments-list');
                //widget.onChange(3);
              },
            ),
            const SizedBox(height: 12,),
          ],
        ),
      ) :
      Container(
        key: ValueKey('DrawerClosed'),
        width: 100,
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(kCornerRadius),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 1
              )
            ]
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    // color: Colors.transparent,
                    shape: BoxShape.circle,
                    // borderRadius: BorderRadius.circular(kCornerRadius),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 1
                      )
                    ]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kCornerRadius),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset( "assets/icons/icon3.png",
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),


            DrawerItem(
              iconData: Icons.local_shipping_outlined,
              title: 'Create Shipment',
              selected: widget.selectedIndex == 0,
              isSmall: true,
              onCLick: () {
                GoRouter.of(context).go('/create-shipment');
              },
            ),
            const SizedBox(height: 12,),
            DrawerItem(
              iconData: Icons.list_alt,
              title: 'Shipments List',
              selected: widget.selectedIndex == 1,
              isSmall: true,
              onCLick: () {
                GoRouter.of(context).go('/shipments-list');
              },
            ),
            const SizedBox(height: 12,),
            DrawerItem(
              iconData: Icons.people_outline,
              title: 'Customers List',
              selected: widget.selectedIndex == 2,
              isSmall: true,
              onCLick: () {
                GoRouter.of(context).go('/customers-list');
              },
            ),
            const SizedBox(height: 12,),
            DrawerItem(
              iconData: Icons.settings,
              title: 'Settings',
              selected: widget.selectedIndex == 3,
              isSmall: true,
              onCLick: () {

              },
            ),
            const SizedBox(height: 12,),
          ],
        ),
      ),
    );
    // if(widget.opened){
    //   return Container(
    //     width: 300,
    //     decoration: BoxDecoration(
    //         color: AppColors.primary,
    //         borderRadius: BorderRadius.circular(kCornerRadius),
    //         boxShadow: [
    //           BoxShadow(
    //               color: Colors.black12,
    //               blurRadius: 4,
    //               spreadRadius: 1
    //           )
    //         ]
    //     ),
    //     child: Column(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Container(
    //             width: 300,
    //             height: 200,
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(kCornerRadius),
    //                 boxShadow: [
    //                   BoxShadow(
    //                       color: Colors.black12,
    //                       blurRadius: 4,
    //                       spreadRadius: 1
    //                   )
    //                 ]
    //             ),
    //             child: ClipRRect(
    //               borderRadius: BorderRadius.circular(kCornerRadius),
    //               child: Image.asset( "assets/icons/icon1.jpg",
    //                 width: 300,
    //                 height: 300,
    //                 fit: BoxFit.contain,
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   );
    // } else {
    //   return Container(
    //     width: 100,
    //     decoration: BoxDecoration(
    //         color: AppColors.primary,
    //         borderRadius: BorderRadius.circular(kCornerRadius),
    //         boxShadow: [
    //           BoxShadow(
    //               color: Colors.black12,
    //               blurRadius: 4,
    //               spreadRadius: 1
    //           )
    //         ]
    //     ),
    //     child: Column(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Container(
    //             width: 100,
    //             height: 100,
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 shape: BoxShape.circle,
    //                 // borderRadius: BorderRadius.circular(kCornerRadius),
    //                 boxShadow: [
    //                   BoxShadow(
    //                       color: Colors.black12,
    //                       blurRadius: 4,
    //                       spreadRadius: 1
    //                   )
    //                 ]
    //             ),
    //             child: ClipRRect(
    //               borderRadius: BorderRadius.circular(kCornerRadius),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: SizedBox(
    //                   width: 80,
    //                   height: 80,
    //                   child: Image.asset( "assets/icons/icon2.png",
    //                     fit: BoxFit.contain,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   );
    // }
    
    
    
  }
}



class DrawerItem extends StatefulWidget {
  final IconData iconData;
  final String title;
  final bool selected;
  final VoidCallback onCLick;
  final bool isSmall;

  const DrawerItem({super.key, required this.iconData, required this.title, required this.selected, required this.onCLick,this.isSmall = false});

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {

  bool hover = false;

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = AppColors.primary;
    Color backgroundColor = Colors.white;

    if (widget.selected) {
      foregroundColor = Colors.white;
      backgroundColor = AppColors.secondary;
    }

    if(widget.isSmall){
      return InkWell(
        onTap: widget.onCLick,
        onHover: (value){
          setState(() {
            hover = value;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: (hover && !widget.selected) ? backgroundColor.withAlpha(150) :  backgroundColor,
              shape: BoxShape.circle
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 8,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20
          ),
          child: Icon(widget.iconData , color: foregroundColor,),
        ),
      );
    }


    return InkWell(
      onTap: widget.onCLick,
      onHover: (value){
        setState(() {
          hover = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: (hover && !widget.selected) ? backgroundColor.withAlpha(150) :  backgroundColor,
            borderRadius: BorderRadius.circular(kCornerRadius)
        ),
        margin: EdgeInsets.symmetric(
            horizontal: 16,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16
        ),
        child: Row(
          children: [
            Icon(widget.iconData , color: foregroundColor,),
            const SizedBox(width: 16,),
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 16,
                  color: foregroundColor,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
