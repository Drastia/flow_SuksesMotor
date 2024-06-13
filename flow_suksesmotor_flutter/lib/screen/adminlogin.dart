import 'dart:convert';

import 'package:flow_suksesmotor/roundedbutton.dart';
import 'package:flow_suksesmotor/services/admin_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flow_suksesmotor/admin/admin_dashboard.dart';
import 'package:http/http.dart' as http;


class LoginAdmin extends StatefulWidget {
  const LoginAdmin({super.key});

  @override
  State<LoginAdmin> createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  String _admin_username='';
  String _admin_password='';

  loginAdminPressed()async{
    if(_admin_username != null && _admin_password != null){
      http.Response response = await AuthServices.loginadmin(_admin_username,_admin_password);
      Map responseMap = jsonDecode(response.body);
      if(response.statusCode==200){
        String adminName = responseMap['admin']['admin_name'];
        Navigator.pushReplacement(
                 context, 
                   MaterialPageRoute(
                     builder: (BuildContext context) =>  AdminDashboard(adminName: adminName),
                   )); 
      }else{
        if (responseMap != null && responseMap.isNotEmpty) {
        // Display all error messages
        List<String> errorMessages = [];
        responseMap.forEach((key, value) {
          if (value is List) {
            errorMessages.addAll(value.map((error) => error.toString()));
          } else {
            errorMessages.add(value.toString());
          }
        });
        // Show all errors in a single SnackBar
        errorSnackBar(context, errorMessages.join("\n"));
        } else {
        // If responseMap is null or empty, show a generic error message
          errorSnackBar(context, "Server error: ${response.statusCode}");
        }
      }
    }else{
      errorSnackBar(context, "enter all the necessary field");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Login Admin',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, 
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 0,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'enter your username',
              ),
              onChanged: (value){
                _admin_username = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'enter your password',
              ),
              onChanged: (value){
                _admin_password = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedButton(btnText: 'Login', onBtnPressed:()=>loginAdminPressed(),)
          ],
        ),
        ));
  }
}