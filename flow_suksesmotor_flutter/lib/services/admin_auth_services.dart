import 'dart:convert';

import 'package:flow_suksesmotor/services/globals.dart';
import 'package:http/http.dart' as http;

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
}