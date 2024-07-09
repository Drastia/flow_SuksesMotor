import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flow_suksesmotor/services/globals.dart';

class ItemServices {
  

  Future<List<dynamic>> fetchItems() async {
    var result = await http.get(Uri.parse(baseURL+'getitems'));
    return json.decode(result.body);
  }

  Future<http.Response> addItem(Map<String, dynamic> data) async {
    var result = await http.post(Uri.parse(baseURL+'storeitems'),
        headers: headers, body: json.encode(data));
    return result;
  }

 Future<List<Map<String, dynamic>>> searchItems(String query) async {
  try {
    var response = await http.get(Uri.parse(baseURL + 'searchitem/$query'), headers: headers);
    var data = json.decode(response.body);
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    } else {
      return []; 
    }
  } catch (error, stackTrace) {
  print('Error searching items: $error');
  print(stackTrace);
  throw error;
}
}

  Future<http.Response> updateItem(int id, Map<String, dynamic> data, String adminName) async {
  var result = await http.put(Uri.parse(baseURL + 'updateitems/$id/$adminName'),
      headers: headers, body: json.encode(data));
  return result;
}
  
  Future<http.Response> deleteItem(int itemId) async {
    
    var result = await http.delete(Uri.parse(baseURL+'deleteitems/$itemId'), headers: headers);
    return result;
  }

}