import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(floatingActionButton:FloatingActionButton(onPressed: () {
      context.pop();
    },child: Icon(Icons.keyboard_return),),body: Center(child: Text("Detail page",style:TextStyle(fontSize: 40)),),);
  }
}
