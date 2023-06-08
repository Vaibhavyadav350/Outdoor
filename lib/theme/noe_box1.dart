import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NeuBox extends StatelessWidget {
  final value;
  const NeuBox({Key? key,required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(

      padding: EdgeInsets.all(7),
      child: value,
      decoration: BoxDecoration(

          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade400,blurRadius: 15,offset: Offset(3,3)),
            BoxShadow(color: Colors.grey.shade400,blurRadius: 15,offset: Offset(-3,-3))
          ]

      ),
    );
  }
}
