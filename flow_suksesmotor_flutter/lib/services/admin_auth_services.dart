import 'dart:convert';

import 'package:flow_suksesmotor/services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:bcrypt/bcrypt.dart';

class AuthServices{
  static Future<http.Response> registeradmin(
    String admin_name, String admin_username, String admin_password ) async {
  Map data = {
    "admin_name": admin_name,
    "admin_username": admin_username,
    "admin_password": admin_password
  };
  var body = json.encode(data);
  var url = Uri.parse(baseURL+ 'registeradmin');
  http.Response response = await http.post(
    url,
    headers: headers,
    body: body,
  );
  print(response.body);
  return response;
  }

  static Future<http.Response> loginadmin(
    String admin_username, String admin_password ) async {
  Map data = {
    "admin_username": admin_username,
    "admin_password": admin_password
  };
  var body = json.encode(data);
  var url = Uri.parse(baseURL+ 'loginadmin');
  http.Response response = await http.post(
    url,
    headers: headers,
    body: body,
  );
  print(response.body);
  return response;
  }

  

  Future<http.Response> updateAdmin(int adminId, Map<String, dynamic> data) async {
    
  var result = await http.put(Uri.parse(baseURL + 'updateadmin/$adminId'),
      headers: headers, 
      body: json.encode(data));
  return result;
}
  
  Future<http.Response> deleteAdmin(int adminId) async {
    var result = await http.delete(Uri.parse(baseURL+'deleteadmin/$adminId'), headers: headers);
    return result;
  } 

   Future<List<dynamic>> fetchAdmin() async {
    var result = await http.get(Uri.parse(baseURL+'admin'));
    return json.decode(result.body);
  }
}