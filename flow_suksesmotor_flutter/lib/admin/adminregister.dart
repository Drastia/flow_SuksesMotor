import 'dart:convert';

import 'package:flow_suksesmotor/admin/admin_dashboard.dart';
import 'package:flow_suksesmotor/admin/registerScreen.dart';
import 'package:flow_suksesmotor/screen/adminlogin.dart';
import 'package:flow_suksesmotor/screen/logintest.dart';
import 'package:flow_suksesmotor/services/admin_auth_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flutter/material.dart';

import '../roundedbutton.dart';
import 'package:http/http.dart' as http;

class adminregister extends StatefulWidget{
  const adminregister({Key? key}) : super(key: key);

  @override
  _adminregisterstate createState() => _adminregisterstate();
}

class _adminregisterstate extends State<adminregister> {
  String _admin_username='';
  String _admin_password='';
  String _admin_name='';

  createAdminAccountPressed() async {
    bool usernameValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_'{|}~]+").hasMatch(_admin_username);
    if(usernameValid){
      http.Response response = await AuthServices.registeradmin(_admin_name, _admin_username, _admin_password);
      
      Map responseMap = jsonDecode(response.body);
      
      if(response.statusCode==200){
         Navigator.pushReplacement( // Use pushReplacement to replace the current route with the dashboard
        context, 
        MaterialPageRoute(
          builder: (BuildContext context) =>  RegisterScreen(),
        ),
      ); 
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
      errorSnackBar(context, "username not valid");
    }
  }
  
  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Admin Registration',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Admin Name',
              ),
              onChanged: (value){
                _admin_name = value;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Admin Username',
              ),
              onChanged: (value){
                _admin_username = value;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Admin Password',
              ),
              onChanged: (value){
                _admin_password = value;
              },
            ),
            const SizedBox(
              height: 40,
            ),
            RoundedButton(
              btnText: 'Create Account',
              onBtnPressed: ()=> createAdminAccountPressed(),
            ),
            const SizedBox(
              height: 40,
            ),
            //ini kayaknyo dksah
            // GestureDetector(
            //   onTap: (){
            //     Navigator.push(
            //       context, 
            //       MaterialPageRoute(
            //         builder: (BuildContext context) => const LoginAdmin(),
            //       )); 
            //   },
            //   child: const Text(
            //     'already have an account',
            //     style: TextStyle(
            //       decoration: TextDecoration.underline,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
      
  }
}