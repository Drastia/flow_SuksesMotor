import 'dart:convert';

import 'package:flow_suksesmotor/admin/choose_order_item.dart';
import 'package:flow_suksesmotor/admin/choose_order_item_edit.dart';
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
        builder: (context) => ChooseItemOrderEdit(),
      ),
    );
    if (newItem != null) {
      addItem(newItem as Map<String, dynamic>);
    }
  }

  Future<void> updateItems() async {
    List<Map<String, dynamic>> allItems = [];

    // Fetch existing items from the order
    var existingItems = await OrderServices().fetchOrderItems(widget.orderId);
    // Cast the existingItems to List<Map<String, dynamic>>
    allItems.addAll(existingItems.cast<Map<String, dynamic>>());

    // Add new items
    allItems.addAll(items);

    var orderData = {'items': allItems};
    print(orderData); // Print orderData to check its structure
    var response =
        await OrderServices().updateOrderItems(widget.orderId, orderData);
    print(response.body); // Print the response body received from the server
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order items updated successfully!')),
      );
      setState(() {
        items.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order items.')),
      );
    }
  }

  void deleteOrderItem(int orderItemId) async {
    var response = await OrderServices().deleteOrderItem(orderItemId);
    if (response.statusCode == 204) {
      // Order item deleted successfully
      setState(() {
        // Remove the deleted item from the local list
        items.removeWhere((item) => item['id'] == orderItemId);
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: openItemSelectionScreen,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshItems,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: OrderServices().fetchOrderItems(
                  widget.orderId), // Fetch order items for the orderId
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    (snapshot.data as List).isEmpty) {
                  return Center(child: Text('No items found.'));
                } else {
                  // Display order items
                  List<dynamic> orderItems = snapshot.data as List<dynamic>;
                  return ListView.builder(
                    itemCount: orderItems.length + items.length,
                    itemBuilder: (context, index) {
                      if (index < orderItems.length) {
                        // Display items fetched from the server
                        var orderItem = orderItems[index];
                        return Card(
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            title: Text('Item: ${orderItem['name']}'),
                            subtitle: Text(
                                'Quantity: ${orderItem['Quantity_ordered']} \nBrand: ${orderItem['brand']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // IconButton(
                                //   icon: Icon(Icons.edit),
                                //   onPressed: () {
                                //     // Implement edit functionality here
                                //   },
                                // ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleteOrderItem(orderItem['id']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Display items added locally
                        var newItem = items[index - orderItems.length];
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
                                // IconButton(
                                //   icon: Icon(Icons.edit),
                                //   onPressed: null, // Disable edit button
                                // ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: null, // Disable delete button
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
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
