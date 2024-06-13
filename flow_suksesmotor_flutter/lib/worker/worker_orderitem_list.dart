import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/order_services.dart';

class WorkerOrderListItems extends StatefulWidget {
  final int orderId;
  final String workerName;

  WorkerOrderListItems({required this.orderId, required this.workerName});

  @override
  _WorkerOrderListItemsState createState() => _WorkerOrderListItemsState();
}

class _WorkerOrderListItemsState extends State<WorkerOrderListItems> {
  List<Map<String, dynamic>> items = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    fetchItems();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() async {
    try {
      var searchedOrderItem = await OrderServices().searchOrderItem(widget.orderId, _searchController.text);
      setState(() {
        items = searchedOrderItem;
      });
    } catch (error) {
      print('Error searching items: $error');
    }
  }

  Future<void> fetchItems() async {
    var existingItems = await OrderServices().fetchOrderItems(widget.orderId);
    setState(() {
      items = existingItems.cast<Map<String, dynamic>>();
    });
  }

  Future<void> updateQuantityArrived(int orderId, Map<String, dynamic> item) async {
    var response = await OrderServices().updateQuantityArrived(orderId, item);

    if (response.statusCode == 200) {
      // Successfully updated
      print('Order item updated successfully!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order item updated successfully!')),
      );
    } else {
      // Failed to update
      print('Failed to update order item: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order item.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker order Items'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchItems,
          ),
          IconButton(
            icon: Image.asset('images/scanner.png', width: 24),
            onPressed: () {
              // Handle camera icon press
            },
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                var orderItem = items[index];

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
                      'Brand: ${orderItem['brand']} \nQuantity Ordered: ${orderItem['Quantity_ordered']} \nQuantity Arrived: ${orderItem['Incoming_Quantity']} \nChecker Barang: ${orderItem['checker_barang']}',
                    ),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: Image.asset('images/text.png', width: 24),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Enter Quantity Arrived'),
                                content: TextField(
                                  controller: TextEditingController(
                                    text: orderItem['Incoming_Quantity'].toString(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        orderItem['Incoming_Quantity'] = int.parse(value);
                                      });
                                    }
                                  },
                                ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            final itemToUpdate = {
                                              'custom_id': orderItem['custom_id'],
                                              'name': orderItem['name'],
                                              'brand': orderItem['brand'],
                                              'Quantity_ordered': orderItem['Quantity_ordered'],
                                              'Incoming_Quantity': orderItem['Incoming_Quantity'],
                                              'checker_barang': widget.workerName,
                                            };

                                            updateQuantityArrived(widget.orderId, itemToUpdate);
                                            Navigator.pop(context);
                                            fetchItems(); // Refresh items after update
                                          },
                                          child: Text('Save'),
                  ),
                                ],
                              ),
                            );
                          },
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