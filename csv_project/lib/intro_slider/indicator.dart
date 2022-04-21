import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Indicator extends AnimatedWidget {
  final PageController controller;
  const Indicator({required this.controller}) : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 40,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _createIndicator(index);
                })
          ],
        ),
      ),
    ); 
  }

  Widget _createIndicator(index) {
    double w = 10;
    double h = 10;
    MaterialColor color = Colors.grey; 

    

    return Container(
      width:14,
      height: 14,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          color: controller.page == index
              ?Color(0xff18224C) 
              : Colors.white),
    );
  }
}
