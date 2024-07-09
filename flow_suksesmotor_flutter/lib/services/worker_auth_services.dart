import 'dart:convert';

import 'package:flow_suksesmotor/services/globals.dart';
import 'package:http/http.dart' as http;

class AuthServices{
  static Future<http.Response> registerworker(
    String worker_name, String worker_username, String worker_password ) async {
  Map data = {
    "worker_name": worker_name,
    "worker_username": worker_username,
    "worker_password": worker_password
  };
  var body = json.encode(data);
  var url = Uri.parse(baseURL+ 'registerworker');
  http.Response response = await http.post(
    url,
    headers: headers,
    body: body,
  );
  print(response.body);
  return response;
  }

  static Future<http.Response> loginworker(
    String worker_username, String worker_password ) async {
  Map data = {
    "worker_username": worker_username,
    "worker_password": worker_password
  };
  var body = json.encode(data);
  var url = Uri.parse(baseURL+ 'loginworker');
  http.Response response = await http.post(
    url,
    headers: headers,
    body: body,
  );
  print(response.body);
  return response;
  }

    Future<http.Response> updateWorker(int workerId, Map<String, dynamic> data, String adminName) async {
  var result = await http.put(Uri.parse(baseURL + 'updateworker/$workerId/$adminName'),
      headers: headers, body: json.encode(data));
  return result;
}
  
  Future<http.Response> deleteWorker(int workerId) async {
    var result = await http.delete(Uri.parse(baseURL+'deleteworker/$workerId'), headers: headers);
    return result;
  } 

  Future<List<dynamic>> fetchWorker() async {
    var result = await http.get(Uri.parse(baseURL+'worker'));
    return json.decode(result.body);
  }
}