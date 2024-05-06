import 'package:flow_suksesmotor/admin/registerScreen.dart';
import 'package:flow_suksesmotor/screen/workerlogin.dart';
import 'package:flow_suksesmotor/screen/logintest.dart';
import 'package:flow_suksesmotor/worker/worker_dashboard.dart';
import 'package:flow_suksesmotor/services/worker_auth_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flutter/material.dart';
import '../roundedbutton.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class workerregister extends StatefulWidget{
  const workerregister({Key? key}) : super(key: key);

  @override
  _workerregisterstate createState() => _workerregisterstate();
}

class _workerregisterstate extends State<workerregister> {
  String _worker_username='';
  String _worker_password='';
  String _worker_name='';

  createWorkerAccountPressed() async{
    bool usernameValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_'{|}~]+").hasMatch(_worker_username);
    if(usernameValid){
      http.Response response = await AuthServices.registerworker(_worker_name, _worker_username, _worker_password);
      
      Map responseMap = jsonDecode(response.body);
      
      if(response.statusCode==200){
        Navigator.pushReplacement( // Use pushReplacement to replace the current route with the dashboard
        context, 
        MaterialPageRoute(
          builder: (BuildContext context) =>  RegisterScreen(),
        ),); 
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
          'worker Registration',
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
                hintText: 'worker Name',
              ),
              onChanged: (value){
                _worker_name = value;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'worker Username',
              ),
              onChanged: (value){
                _worker_username = value;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'worker Password',
              ),
              onChanged: (value){
                _worker_password = value;
              },
            ),
            const SizedBox(
              height: 40,
            ),
            RoundedButton(
              btnText: 'Create Account',
              onBtnPressed: ()=> createWorkerAccountPressed(),
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
            //         builder: (BuildContext context) => const Loginworker(),
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