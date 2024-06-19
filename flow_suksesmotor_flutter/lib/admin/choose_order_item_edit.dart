import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/item_services.dart';

class ChooseItemOrderEdit extends StatefulWidget {
  const ChooseItemOrderEdit({Key? key}) : super(key: key);

  @override
  State<ChooseItemOrderEdit> createState() => _ChooseItemOrderEditState();
}

class _ChooseItemOrderEditState extends State<ChooseItemOrderEdit> {
  final ItemServices _itemServices = ItemServices();
  List<Map<String, dynamic>> _items = [];
  Map<String, dynamic>? _selectedItem;
  TextEditingController _quantityController = TextEditingController();
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

  void _onSearchChanged() {
    _itemServices.searchItems(_searchController.text).then((searchedItems) {
      setState(() {
        _items = searchedItems;
      });
    }).catchError((error) {
      print('Error searching items: $error');
      
    });
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
    _quantityController.clear(); // Clear the quantity controller

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
                if (_quantityController.text.isNotEmpty) {
                  if (RegExp(r'^\d+$').hasMatch(_quantityController.text)) {
                  setState(() {
                    _selectedItem = Map.from(item);
                    _selectedItem!['Quantity_ordered'] = _quantityController.text;
                  });
                  Navigator.pop(context);
                  Navigator.pop(context, _selectedItem);
                  }else{
                     errorSnackBar(context,
                        'Please enter a valid quantity (whole numbers only)');
                  }
                }
                else{
                  errorSnackBar(context, 'silahkan isi banyak barangnya');
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
          backgroundColor: Color(0xFF52E9AA),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchItems();
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
          Expanded( 
            child: ListView.builder(
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
    )
    ],
      ),
    );
  }
}
