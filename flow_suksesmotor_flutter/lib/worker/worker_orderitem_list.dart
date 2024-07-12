import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flow_suksesmotor/worker/OCR_scanner.dart';
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
  TextEditingController _quantityController = TextEditingController();

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
      var searchedOrderItem = await OrderServices()
          .searchOrderItem(widget.orderId, _searchController.text);
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

  Future<void> updateQuantityArrived(
      int orderId, Map<String, dynamic> item) async {
    var response = await OrderServices().updateQuantityArrived(orderId, item, widget.workerName);

    if (response.statusCode == 200) {

      print('Order item updated successfully!');
      successSnackBar(context,'Order items updated successfully!');
    } else {
      
      print('Failed to update order item: ${response.body}');
      errorSnackBar(context,'Failed to update order item.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker order Items'),
          backgroundColor: Color(0xFF52E9AA),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchItems,
          ),
          IconButton(
            icon: Image.asset('images/scanner.png', width: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OcrScanner(
                    orderId: widget.orderId,
                    workerName: widget.workerName,
                    items: items,
                  ),
                ),
              ).then((result) {
                if (result ?? false) {
                  fetchItems(); 
                }
              });
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
    child: Text(
      'ID Pemesan: ${widget.orderId}',
      style: TextStyle(fontSize: 16.0),
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
                          ? Colors.grey[50]
                          : Colors.grey[50],
                  child: ListTile(
                    title: Text('ID Barang: ${orderItem['custom_id']}'),
                    subtitle: Text(
                      'Item: ${orderItem['name']}\nBrand: ${orderItem['brand']} \nQuantity Arrived: ${orderItem['Incoming_Quantity']} \nChecker Barang: ${orderItem['checker_barang']}',
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
                                  controller: _quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(labelText: 'Quantity'),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      if (RegExp(r'^\d+$').hasMatch(_quantityController.text)) {
                                      setState(() {
                                        orderItem['Incoming_Quantity'] =
                                            int.parse(value);
                                      });
                                      }else{
                                        errorSnackBar(context,
                                              'Please enter a valid quantity (whole numbers only)');
                                      }
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
                                      if (_quantityController.text.isNotEmpty) {
                                        if (RegExp(r'^\d+$').hasMatch(
                                            _quantityController.text)) {
                                          final itemToUpdate = {
                                            'custom_id': orderItem['custom_id'],
                                            'name': orderItem['name'],
                                            'brand': orderItem['brand'],
                                            'Quantity_ordered':
                                                orderItem['Quantity_ordered'],
                                            'Incoming_Quantity':
                                                orderItem['Incoming_Quantity'],
                                            'checker_barang': widget.workerName,
                                          };

                                          updateQuantityArrived(
                                              widget.orderId, itemToUpdate);
                                          _quantityController.clear();
                                          Navigator.pop(context);
                                          fetchItems(); 
                                        } else {
                                          errorSnackBar(context,
                                              'Please enter a valid quantity (whole numbers only)');
                                        }
                                      } else {
                                        errorSnackBar(context,
                                            'silahkan isi banyak barangnya');
                                      }
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
