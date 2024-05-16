import 'dart:convert';

import 'package:flow_suksesmotor/admin/edit_orderlist.dart';
import 'package:flow_suksesmotor/admin/read_orderitems.dart';
import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/order_services.dart';

class ListOrders extends StatefulWidget {
  @override
  _ListOrdersState createState() => _ListOrdersState();
}

class _ListOrdersState extends State<ListOrders> {
  List<dynamic> orders = [];
  OrderServices _orderServices = OrderServices();

  @override
  void initState() {
    super.initState();
    _orderServices.fetchOrders().then((data) {
      setState(() {
        orders = data;
      });
    });
  }

  Future<void> deleteOrder(int orderId) async {
    // Call the deleteOrder method from OrderServices
    var response = await _orderServices.deleteOrder(orderId);
    if (response.statusCode == 204) {
      // Order deleted successfully, fetch updated data
      var updatedOrders = await _orderServices.fetchOrders();
      setState(() {
        orders = updatedOrders;
      });
      // Show a snackbar or toast message indicating success
      successSnackBar(context, 'Delete is successful');
    } else if (response.statusCode == 404) {
      // Order not found, show error message
      errorSnackBar(context, 'Order not found');
    } else {
      // Other error, extract error message from response
      var errorMessage = json.decode(response.body)['message'];
      print(errorMessage);
      errorSnackBar(context, errorMessage ?? 'Failed to delete order');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(orders);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      body: orders.isEmpty
          ? Center(
              child: Text(
                'There is no order',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID pemesanan : ${orders[index]['ID_pemesanan']}',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        // Date centered
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Vendor: ${orders[index]['nama_vendor']}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Spacer(), // Pushes the text "Pemesan" to the end
                            Text(
                              'Pemesan: ${orders[index]['nama_pemesan']}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            '${orders[index]['tanggal_pemesanan']} -> ${orders[index]['tanggal_sampai']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditOrderList(
                                      ID_pemesanan: orders[index]
                                          ['ID_pemesanan'],
                                      Tanggal_pemesanan: orders[index]
                                          ['tanggal_pemesanan'],
                                      Tanggal_sampai: orders[index]
                                          ['tanggal_sampai'],
                                      Nama_Vendor: orders[index]['nama_vendor'],
                                      Nama_Pemesan: orders[index]
                                          ['nama_pemesan'],
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Call the deleteOrder method when delete icon is pressed
                                deleteOrder(orders[index]['ID_pemesanan']);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.note),
                              onPressed: () {
                                // Navigate to the OrderItemsScreen to display order items
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReadOrderItems(
                                        
                                        orderId: orders[index]['ID_pemesanan']),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
