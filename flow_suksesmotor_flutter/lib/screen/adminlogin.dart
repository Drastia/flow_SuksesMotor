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
  bool _isPasswordInvisible = false;

  loginAdminPressed()async{
     try {  
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
        
        List<String> errorMessages = [];
        responseMap.forEach((key, value) {
          if (value is List) {
            errorMessages.addAll(value.map((error) => error.toString()));
          } else {
            errorMessages.add(value.toString());
          }
        });
        
        errorSnackBar(context, errorMessages.join("\n"));
        } else {
        
          errorSnackBar(context, "Server error: ${response.statusCode}");
        }
      }
    }else{
      errorSnackBar(context, "enter all the necessary field");
    }
     }catch(e){
      errorSnackBar(context, "an error occured (maybe related to server)");
     }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF52E9AA),
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
            SizedBox(height: 20),
            TextField(
              decoration:  InputDecoration(
                hintText: 'enter your username',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              ),
              onChanged: (value){
                _admin_username = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
                obscureText: !_isPasswordInvisible,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordInvisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordInvisible = !_isPasswordInvisible;
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  _admin_password = value;
                },
              ),
            const SizedBox(
              height: 20,
            ),
            RoundedButton(
                btnText: 'Login',
                
                onBtnPressed: () => loginAdminPressed(),
              ),
          ],
        ),
        ));
  }
}