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
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    _orderServices.fetchOrdersAfterToday().then((data) {
      setState(() {
        orders = data;
      });
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() async {
    
      try {
        var searchedOrder = await _orderServices.searchOrder(_searchController.text);
     
        setState(() {
          orders = searchedOrder;
        });
      } catch (error) {
        print('Error searching items: $error');
      }
    
  }

  Future<void> fetchOrders() async {
    var existingOrders = await OrderServices().fetchOrdersAfterToday();
    setState(() {
      orders = existingOrders.cast<Map<String, dynamic>>();
    });
  }

  Future<void> deleteOrder(int orderId) async {
    var response = await _orderServices.deleteOrder(orderId);
    if (response.statusCode == 204) {
      var updatedOrders = await _orderServices.fetchOrdersAfterToday();
      setState(() {
        orders = updatedOrders;
      });
      successSnackBar(context, 'Delete is successful');
    } else if (response.statusCode == 404) {
      errorSnackBar(context, 'Order not found');
    } else {
      var errorMessage = json.decode(response.body)['message'];
      print(errorMessage);
      errorSnackBar(context, errorMessage ?? 'Failed to delete order');
    }
  }

  Widget _buildCheckIcon(dynamic order) {
    if (order['checked'] == null) {
      return SizedBox(width: 24);
    } else if (order['checked'] == 'true') {
      return Icon(Icons.check, color: Colors.green);
    } else {
      return Icon(Icons.clear, color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
        backgroundColor: Color(0xFF52E9AA),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchOrders,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey[200],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: orders.isEmpty
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ID pemesanan : ${orders[index]['ID_pemesanan']}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _buildCheckIcon(orders[index]),
                              ],
                            ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Vendor: ${orders[index]['nama_vendor']}',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                  Spacer(),
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
                                            ID_pemesanan:
                                                orders[index]['ID_pemesanan'],
                                            Tanggal_pemesanan: orders[index]
                                                ['tanggal_pemesanan'],
                                            Tanggal_sampai: orders[index]
                                                ['tanggal_sampai'],
                                            Nama_Vendor:
                                                orders[index]['nama_vendor'],
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
                                      deleteOrder(
                                          orders[index]['ID_pemesanan']);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.note),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReadOrderItems(
                                              orderId: orders[index]
                                                  ['ID_pemesanan']),
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
          ),
        ],
      ),
    );
  }
}
