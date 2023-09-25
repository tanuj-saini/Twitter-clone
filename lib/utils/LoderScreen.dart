import 'package:flutter/material.dart';

class LoderScreen extends StatefulWidget{
  LoderScreen({super.key});
  @override
  State<StatefulWidget> createState() {
   return _LoderScreen();
  }
  
}
class _LoderScreen extends State<LoderScreen>{
  @override
  Widget build(BuildContext context) {
   return  const  Scaffold(body: Center(child: CircularProgressIndicator(),),);
  }
}