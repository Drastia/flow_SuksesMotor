import 'dart:convert';

import 'package:flow_suksesmotor/admin/edit_orderlist.dart';
import 'package:flow_suksesmotor/admin/read_orderitems.dart';
import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flow_suksesmotor/worker/worker_orderitem_list.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/order_services.dart';
import 'package:intl/intl.dart';

class WorkerOrderHistory extends StatefulWidget {
  final String workerName;
  WorkerOrderHistory({required this.workerName});

  @override
  _WorkerOrderHistoryState createState() => _WorkerOrderHistoryState();
}

class _WorkerOrderHistoryState extends State<WorkerOrderHistory>
    with WidgetsBindingObserver {
  List<dynamic> orders = [];
  OrderServices _orderServices = OrderServices();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchOrders();
     _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      // Update the text field with the selected date
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
    if (picked != null && picked != controller.text) {
      // Update the text field with the selected date

      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  void _onSearchChanged() async {
    
      try {
        var searchedOrder = await _orderServices.searchOrderHistory(_searchController.text);
     
        setState(() {
          orders = searchedOrder;
        });
      } catch (error) {
        print('Error searching items: $error');
      }
    
  }
  

  Future<void> fetchOrders() async {
    var existingOrders = await OrderServices().fetchOrdersBeforeToday();
    setState(() {
      orders = existingOrders.cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building WorkerOrderHistory with orders: $orders');

    return Scaffold(
      appBar: AppBar(
        title: Text('Worker History Order List'),
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
                       suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: Color(0xFF52E9AA)),
                    onPressed: () =>
                        _selectDate(context, _searchController),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child:orders.isEmpty
          ? Center(
              child: Text(
                'There is no order',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkerOrderListItems(
                            orderId: orders[index]['ID_pemesanan'],
                            workerName: widget.workerName,
                          ),
                        ),
                      ).then((_) {
                        fetchOrders();
                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      )]),
    );
  }

  Widget _buildCheckIcon(dynamic order) {
    if (order['checked'] == '') {
      return SizedBox(width: 24); // Empty space, adjust size as needed
    } else if (order['checked'] == 'true') {
      return Icon(Icons.check, color: Colors.green);
    } else {
      return Icon(Icons.clear, color: Colors.red);
    }
  }
}
