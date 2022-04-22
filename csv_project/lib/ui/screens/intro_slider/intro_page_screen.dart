import 'package:flutter/material.dart';


class IntroPageScreen extends StatelessWidget {
  static const id = 'IntroPageScreen';

  final String message;
  final String title;
  final String image;

  IntroPageScreen(this.message, this.image,this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color:Color(0xff18224C) ,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.width / 6),
          Image.asset(
            image,
            fit: BoxFit.scaleDown,
            width: 240,
            height: 240,
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                   title,
                 ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              
               message,
               style: TextStyle(color: Colors.white),
               ),
          )
        ],
      ),
    );
  }
}
