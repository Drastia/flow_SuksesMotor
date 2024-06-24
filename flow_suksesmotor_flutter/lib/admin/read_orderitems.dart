import 'dart:convert';

import 'package:flow_suksesmotor/admin/choose_order_item.dart';
import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/order_services.dart'; // Import the OrderServices class

class ReadOrderItems extends StatefulWidget {
  final int orderId;
  ReadOrderItems({required this.orderId});

  @override
  _ReadOrderItemsState createState() => _ReadOrderItemsState();
}

class _ReadOrderItemsState extends State<ReadOrderItems> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> serverItems = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItems();
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
      var searchedOrderItem = await OrderServices()
          .searchOrderItem(widget.orderId, _searchController.text);

      setState(() {
        serverItems = searchedOrderItem;
      });
    } catch (error) {
      print('Error searching items: $error');
    }
  }

  Future<void> fetchItems() async {
    var existingItems = await OrderServices().fetchOrderItems(widget.orderId);
    setState(() {
      serverItems = existingItems.cast<Map<String, dynamic>>();
    });
  }

  Future<void> refreshItems() async {
    setState(() {});
  }

  void addItem(Map<String, dynamic> newItem) {
    setState(() {
      items.add(newItem);
    });
  }

  void openItemSelectionScreen() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseItemOrder(),
      ),
    );
    if (newItem != null) {
      addItem(newItem as Map<String, dynamic>);
    }
  }

  Future<void> updateItems() async {
    List<Map<String, dynamic>> allItems = [];

    // Add existing server items
    allItems.addAll(serverItems);

    // Add new items
    allItems.addAll(items);

    var orderData = {'items': allItems};
    print(orderData); // Print orderData to check its structure
    var response =
        await OrderServices().updateOrderItems(widget.orderId, orderData);
    print(response.body); // Print the response body received from the server
    if (response.statusCode == 200) {

        successSnackBar(context,'Order items updated successfully!');

      setState(() {
        items.clear();
        fetchItems();
      });
    } else {

        errorSnackBar(context,'Failed to update order items.');
      
    }
  }

  void deleteOrderItem(int orderItemId) async {
    var response = await OrderServices().deleteOrderItem(orderItemId);
    if (response.statusCode == 204) {
      // Order item deleted successfully
      setState(() {
        // Remove the deleted item from the local list
        serverItems.removeWhere((item) => item['id'] == orderItemId);
      });
      successSnackBar(context, 'Delete is successful');
      // Refresh items after deletion
      await refreshItems();
    } else if (response.statusCode == 404) {
      errorSnackBar(context, 'Order item not found');
    } else {
      var errorMessage = json.decode(response.body)['message'];
      errorSnackBar(context, errorMessage ?? 'Failed to delete order item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Items'),
        backgroundColor: Color(0xFF52E9AA),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: openItemSelectionScreen,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchItems,
          ),
        ],
      ),
      body: Column(
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
            child: serverItems.isEmpty && items.isEmpty
                ? Center(child: Text('No items found.'))
                : ListView.builder(
                    itemCount: serverItems.length + items.length,
                    itemBuilder: (context, index) {
                      if (index < serverItems.length) {
                        // Display items fetched from the server
                        var orderItem = serverItems[index];
                        return Card(
                          margin: EdgeInsets.all(8),
                          color: orderItem['ismatch'] == ''
                              ? Colors.grey[50]
                              : orderItem['ismatch'] == 'true'
                                  ? Colors.green[100]
                                  : Colors.red[100],
                          child: ListTile(
                            title: Text('Item: ${orderItem['name']}'),
                            subtitle: Text(
                                'Quantity Ordered: ${orderItem['Quantity_ordered']} \nQuantity Arrived: ${orderItem['Incoming_Quantity']}  \nBrand: ${orderItem['brand']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirm Delete'),
                                          content: Text(
                                              'Are you sure you want to delete item with name ' +
                                                  serverItems[index]['name']
                                                      .toString() +
                                                  '?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('No'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Yes'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  deleteOrderItem(orderItem['id']);
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Display items added locally
                        var newItem = items[index - serverItems.length];
                        return Card(
                          margin: EdgeInsets.all(8),
                          color: Colors.lightGreen[
                              100], // Set the card color to light green
                          child: ListTile(
                            title: Text('Item: ${newItem['name']}'),
                            subtitle: Text(
                                'Quantity: ${newItem['Quantity_ordered']} \nBrand: ${newItem['brand']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirm Delete'),
                                          content: Text(
                                              'Are you sure you want to delete item with name ' +
                                                  items[index -
                                                      serverItems.length]['name']
                                                      .toString() +
                                                  '?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('No'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Yes'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  items.removeAt(index -
                                                      serverItems.length);
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: updateItems,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity,
                    50), // Make button full-width and height 50
              ),
              child:
                  Text('Update Items', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
