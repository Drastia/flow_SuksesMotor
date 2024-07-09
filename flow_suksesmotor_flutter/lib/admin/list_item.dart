import 'package:flow_suksesmotor/admin/edit_item.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/item_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';

class ListItem extends StatefulWidget {
   final String adminName;
   ListItem({Key? key, required this.adminName}) : super(key: key);
  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final ItemServices _itemServices = ItemServices();
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> selectedRows = [];
  bool isItemSelected = false;
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
      setState(() {
        _items = fetchedItems.cast<Map<String, dynamic>>();
      });
    } catch (error) {
      print('Error fetching items: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
        backgroundColor: Color(0xFF52E9AA),
        elevation: 0,
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
                bool isSelected = selectedRows.contains(item);
                return Card(
                  color: isSelected ? Colors.green[300] : null,
                  child: ListTile(
                    onTap: () {
                      _handleRowSelection(item);
                    },
                    title: Text('${item['name']}'),
                    subtitle: Text('${item['brand']}'),
                    trailing: Text('${item['custom_id']}'),
                  ),
                );
              },
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isItemSelected
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditItem(selectedItem: selectedRows.first, adminName: widget.adminName,)),
                        );
                      }
                    : null,
                child: Text('Edit', style: TextStyle(color: Colors.white)),
                style: isItemSelected
                    ? ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      )
                    : ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue.withOpacity(0.5)),
                      ),
              ),
              ElevatedButton(
                onPressed: isItemSelected
                    ? () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text(
                                  'Are you sure you want to delete item with name ' +
                                      selectedRows[0]['name'] +
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
                                    _deleteSelectedItems();
                                  },
                                ),
                              ],
                            );
                          },
                        )
                    : null,
                child: Text('Delete', style: TextStyle(color: Colors.white)),
                style: isItemSelected
                    ? ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      )
                    : ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red.withOpacity(0.5)),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleRowSelection(Map<String, dynamic> item) {
    setState(() {
      if (selectedRows.contains(item)) {
        selectedRows.remove(item);
      } else {
        selectedRows.clear();
        selectedRows.add(item);
      }
      isItemSelected = selectedRows.isNotEmpty;
    });
  }

  Future<void> _deleteSelectedItems() async {
    List<String> deletedCustomIDs = [];

    for (var item in selectedRows) {
      var itemId = item['id'];
      deletedCustomIDs.add(item['custom_id']);
      await _itemServices.deleteItem(itemId);
    }

    successSnackBar(context,
        'Item dengan ID ${deletedCustomIDs.join(', ')} berhasil dihapus!');
    fetchItems();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ListItem(adminName: widget.adminName,)),
    );
    setState(() {
      selectedRows.clear();
      isItemSelected = false;
    });
  }
}
