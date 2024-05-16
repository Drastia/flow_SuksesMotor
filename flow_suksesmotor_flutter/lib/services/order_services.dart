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

  Future<List<dynamic>> fetchOrders() async {
    var result = await http.get(Uri.parse(baseURL+'orders'));
    return json.decode(result.body);
  }

  Future<http.Response> updateOrder(int orderId, Map<String, dynamic> orderData) async {
  var result = await http.put(Uri.parse(baseURL + 'orders/$orderId'),
      headers: headers, body: json.encode(orderData));
  return result;
}

   Future<http.Response> updateOrderItems(int orderId, Map<String, dynamic> orderData) async {
  var result = await http.put(Uri.parse(baseURL + 'orders/$orderId/items'),
      headers: headers, body: json.encode(orderData));
  return result;
}

  Future<List<dynamic>> fetchOrderItems(int orderId) async {
    var result = await http.get(Uri.parse(baseURL+'orders/list/$orderId'));
    return json.decode(result.body);
  }

  Future<http.Response> deleteOrder(int orderId) async {
    var result = await http.delete(Uri.parse(baseURL+'orders/$orderId'), headers: headers);
    return result;
  }

  Future<http.Response> deleteOrderItem(int orderitemId) async {
    var result = await http.delete(Uri.parse(baseURL+'orders/$orderitemId/items'), headers: headers);
    return result;
  }
}
