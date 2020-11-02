import 'package:ecommerce_app/Models/authentication.dart';
import 'package:ecommerce_app/Screen/Loging_Screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

//import './Models/Bags.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

import './Screen/Loging_Screen.dart';
import './Screen/SingUp_Screen.dart';
import './Screen/EStoreDemo.dart';
import './Models/authentication.dart';

void main() => runApp(EStore());

class EStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Authentication(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'test',
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: Loging_Screen(),
        routes: {
          SingUp_Screen.routeName: (ctx) => SingUp_Screen(),
          Loging_Screen.routeName: (ctx) => Loging_Screen(),
          EStoreDemo.routeName: (ctx) => EStoreDemo(),
        },
      ),
    );
  }
}
