import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';

class Header extends StatefulWidget {

  final Function(bool) callback;
  final bool isMobile;
  const Header({super.key, required this.callback,this.isMobile = false});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  bool opened = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(kCornerRadius),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(!widget.isMobile)
            AnimatedSwitcher(
              duration: Duration(
                  milliseconds: 300
              ),
              transitionBuilder: (child,animation){
                return FadeTransition(opacity: animation,child: child,);
              },
              child: opened ?
              IconButton(
                key: ValueKey('back'),
                onPressed: () {
                  setState(() {
                    opened = !opened;
                  });
                 widget.callback(opened);
                },
                icon: Icon(Icons.arrow_back , color: Colors.white,size: 25,),
              ):
              IconButton(
                key: ValueKey('menu'),
                onPressed: () {
                  setState(() {
                    opened = !opened;
                  });
                  widget.callback(opened);
                },
                icon: Icon(Icons.menu , color: Colors.white,size: 25,),
              ),
            ),
          if(widget.isMobile)
            IconButton(
              onPressed: () {
                widget.callback(true);
              },
              icon: Icon(Icons.menu , color: Colors.white,size: 25,),
            ),
          Expanded(child: SizedBox()),
          Row(
            children: [
              CircleAvatar(
                radius: 25, // Adjust size as needed
                // backgroundImage: AssetImage('assets/images/admin.jpg'), // Replace with your image path
                backgroundColor: Colors.white, // Fallback color if the image fails to load
                child: Icon(Icons.person , size: 25,color: AppColors.primary,),
              ),
              SizedBox(width: 4), // Spacing between avatar and text
              Text(
                'Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Adjust font size as needed
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
