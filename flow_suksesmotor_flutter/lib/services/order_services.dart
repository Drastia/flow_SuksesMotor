import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flow_suksesmotor/services/globals.dart';

class OrderServices {
    Future<http.Response> createOrder(Map<String, dynamic> orderData) async {
    // Make an HTTP POST request to the API endpoint
    var url = Uri.parse(baseURL+'orders/');
   
    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(orderData),
    );
    

    return response;
  
  }
}
