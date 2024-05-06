import 'package:flow_suksesmotor/roundedbutton.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/worker_auth_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flow_suksesmotor/worker/worker_dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginWorker extends StatefulWidget {
  const LoginWorker({super.key});

  @override
  State<LoginWorker> createState() => _LoginWorkerState();
}

class _LoginWorkerState extends State<LoginWorker> {
  String _worker_username='';
  String _worker_password='';

  loginWorkerPressed()async{
    
    if(_worker_username != null && _worker_password != null){
      http.Response response = await AuthServices.loginworker(_worker_username,_worker_password);
      Map responseMap = jsonDecode(response.body);
      if(response.statusCode==200){
        String workerName = responseMap['worker']['worker_name'];
        Navigator.push(
                 context, 
                   MaterialPageRoute(
                     builder: (BuildContext context) => WorkerDashboard(workerName : workerName),
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
          'Login Worker',
          style: TextStyle(
            fontSize: 10,
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
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'enter your username',
              ),
              onChanged: (value){
                _worker_username = value;
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
                _worker_password = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedButton(btnText: 'Login', onBtnPressed:()=>loginWorkerPressed(),)
          ],
        ),
        ));
  }
}