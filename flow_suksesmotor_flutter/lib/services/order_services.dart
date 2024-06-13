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

  Future<List<dynamic>> fetchOrdersAfterToday() async {
    var result = await http.get(Uri.parse(baseURL+'orders/IndexAftertoday'));
    return json.decode(result.body);
  }
  Future<List<dynamic>> fetchOrdersBeforeToday() async {
    var result = await http.get(Uri.parse(baseURL+'orders/IndexBeforetoday'));
    return json.decode(result.body);
  }

Future<List<dynamic>> searchOrder(String query) async {
  try {
    var response = await http.get(Uri.parse(baseURL + 'orders/searchOrder/$query'), headers: headers);
    if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List) {
          return data;
        } else {
          return []; // Return an empty list if the response is not a list
        }
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error, stackTrace) {
      print('Error searching items: $error');
      print(stackTrace);
      throw error;
    }

}

Future<List<dynamic>> searchOrderHistory(String query) async {
  try {
    var response = await http.get(Uri.parse(baseURL + 'orders/searchOrderHistory/$query'), headers: headers);
    if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List) {
          return data;
        } else {
          return []; // Return an empty list if the response is not a list
        }
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error, stackTrace) {
      print('Error searching items: $error');
      print(stackTrace);
      throw error;
    }

}

Future<List<Map<String, dynamic>>> searchOrderItem(int id,String query) async {
  try {
    var response = await http.get(Uri.parse(baseURL + 'orders/searchOrderItem/$id/$query'), headers: headers);
    if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else {
          return []; // Return an empty list if the response is not a list
        }
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error, stackTrace) {
      print('Error searching items: $error');
      print(stackTrace);
      throw error;
    }

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

  Future<http.Response> updateQuantityArrived(int orderId, Map<String, dynamic> item) async {
  var result = await http.put(Uri.parse(baseURL+ 'orders/$orderId/quantity-item'),
    headers: headers,body: json.encode({'items': [item]}));
    return result;
}

  Future<List<dynamic>> fetchOrderItems(int orderId) async {
    var result = await http.get(Uri.parse(baseURL+'orders/list/$orderId'));
    if (result.statusCode == 200) {
      var body = json.decode(result.body);
      if (body is List) {
        return body;
      } else {
        return [];
      }
    } else {
      
      return [];
    }
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
