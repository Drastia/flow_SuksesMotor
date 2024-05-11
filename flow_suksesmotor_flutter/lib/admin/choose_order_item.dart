import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/item_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';

class ChooseItemOrder extends StatefulWidget {
  const ChooseItemOrder({Key? key}) : super(key: key);

  @override
  State<ChooseItemOrder> createState() => _ChooseItemOrderState();
}

class _ChooseItemOrderState extends State<ChooseItemOrder> {
  final ItemServices _itemServices = ItemServices();
  List<Map<String, dynamic>> _items = [];
  Map<String, dynamic>? _selectedItem;
  TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItems(); // Fetch items when the screen is entered
  }

 void fetchItems() async {
  try {
    var fetchedItems = await _itemServices.fetchItems();
    if (mounted) {
      setState(() {
        _items = fetchedItems.cast<Map<String, dynamic>>();
      });
    }
  } catch (error) {
    print('Error fetching items: $error');
  }
}

  void _showQuantityDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Quantity'),
          content: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Quantity'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add Item'),
              onPressed: () {
                // Adding selected item to the AddOrder screen
                if (_quantityController.text.isNotEmpty) {
                  setState(() {
                    _selectedItem = Map.from(item);
                    _selectedItem!['Quantity_ordered'] = _quantityController.text;
                  });
                  Navigator.pop(context);
                  Navigator.pop(context, _selectedItem);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Item'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchItems();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          var item = _items[index];
          return Card(
            child: ListTile(
              onTap: () {
                _showQuantityDialog(item);
              },
              title: Text('${item['name']}'),
              subtitle: Text('${item['brand']}'),
              trailing: Text('${item['custom_id']}'),
            ),
          );
        },
      ),
    );
  }
}
