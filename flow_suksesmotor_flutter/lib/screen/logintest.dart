import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  final String userType;

  LoginScreen({required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$userType Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: LoginForm(userType: userType),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final String userType;

  LoginForm({required this.userType});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser(String username, String password, String userType) async {
  
  Uri url = Uri.parse('your_laravel_backend_url/login');
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  Map<String, dynamic> body = {
    'username': username,
    'password': password,
  };

  try {
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      
      print('Login successful!');
      
    } else {
      
      print('Login failed: ${response.body}');
    }
  } catch (e) {
    
    print('Error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
          ),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            
            String username = _usernameController.text;
            String password = _passwordController.text;
            loginUser(username, password, widget.userType);
          },
          child: Text('Login'),
        ),
      ],
    );
  }
}
