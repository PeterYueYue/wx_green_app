import 'package:flutter/material.dart';
import 'listData.dart';
import 'Tabs.dart';

void main () => runApp(Home());
class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        home: Tabs()
    );
  }
}



