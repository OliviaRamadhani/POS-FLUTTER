import 'package:flutter/material.dart';

class AppWidget{

  static TextStyle boldTextFeildStyle(){
    return TextStyle(
            color: Colors.black, 
            fontSize: 28.0,
            fontWeight: FontWeight.bold);

  }

  static TextStyle LightTextFieldStyle(){
    return  TextStyle(
      color: Colors.black54, 
      fontSize: 20.0, 
      fontWeight: FontWeight.w500 );
    
  } 

  static TextStyle semiboldTextFieldStyle(){
    return TextStyle(
      color: Colors.black, 
      fontSize: 18.0, 
      fontWeight: FontWeight.bold);
  }
}