import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_project/blocs/timer_bloc.dart';
import 'package:tutor_project/data/session_data.dart';
import 'package:tutor_project/models/session.dart';
import 'package:tutor_project/utils/seconds_formatter.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  Session session=SessionData.session;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SizedBox(
      width: double.infinity,
      child: (Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        SettingWidget(name: "Подходы",isSets: true,seconds: session.sets,),
        SettingWidget(name: "Работа",seconds: session.workingSeconds,),
        SettingWidget(name: "Отдых",seconds: session.restingSeconds,),
        Container(width:double.infinity,height:50,margin:EdgeInsets.symmetric(horizontal: 20),child: ElevatedButton.icon(onPressed: (){
          context.goNamed("timer",extra: SessionData.session);
        }, icon:Icon(Icons.electric_bolt_outlined,color: Colors.yellow,),label: Text("Начать".toUpperCase())))
        ],
      )),
    ),);
  }
}
class SettingWidget extends StatefulWidget {
  String name;
  bool isSets;
  int seconds;
  SettingWidget({Key? key,required this.name,this.isSets=false,required this.seconds}) : super(key: key);

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  late int amount=widget.seconds;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(children: [
        Text(widget.name.toUpperCase(),),
        Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
          IconButton(onPressed: (){
                 setState(() {
                   amount-=widget.isSets?1:5;
                   if(widget.name=="Подходы"){
                     SessionData.session.sets=amount;
                   }else if(widget.name=="Работа"){
                     SessionData.session.workingSeconds=amount;
                   }else if(widget.name=="Отдых"){
                     SessionData.session.restingSeconds=amount;
                   }
                   print(SessionData.session.workingSeconds);
                 });
          }, icon: Icon(Icons.remove)),
          Text(widget.isSets?amount.toString():formatterTime(amount),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
          IconButton(onPressed: (){
            setState(() {
              amount+=widget.isSets?1:5;
              if(widget.name=="Подходы"){
                SessionData.session.sets=amount;
              }else if(widget.name=="Работа"){
                SessionData.session.workingSeconds=amount;
              }else if(widget.name=="Отдых"){
                SessionData.session.restingSeconds=amount;
              }
            });
          }, icon: Icon(Icons.add)),
        ],),
        SizedBox(height: 10,)
      ],
      ),
    );
  }

}
