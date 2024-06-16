

import 'package:flutter/material.dart';

//const String baseURL = "http://127.0.0.1:8000/api/";

//for android emulator
//const String baseURL = "http://10.0.2.2:8000/api/";

//baseURL with physical handphone this api is using wifi IP
//the IP must connected to the same wifi api first
//then on cmd in laptop type ipconfig and look for ipv4 ip address on the wifi IP
//copy it and paste on this baseURL variable then type "php artisan serve --host 0.0.0.0" on this terminal 
//DONT CHANGE THE :8000/api/ 

//api wifi rumah
//const String baseURL = "http://192.168.1.4:8000/api/";


//MDP gedung B
const String baseURL = "http://192.168.45.219:8000/api/";

const Map<String, String> headers = {"Content-Type" : "application/json", 'Accept' : 'application/json'};

errorSnackBar(BuildContext context, String text){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(text),
    duration: const Duration(seconds: 3),
      ));
  
}

successSnackBar(BuildContext context, String text){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text(text),
    duration: const Duration(seconds: 3),
      ));
  
}
