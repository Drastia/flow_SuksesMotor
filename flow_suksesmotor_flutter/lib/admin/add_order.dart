import 'package:flow_suksesmotor/services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/item_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';
import 'choose_order_item.dart'; 
import 'package:intl/intl.dart';

class AddOrder extends StatefulWidget {
  final String adminName;
  AddOrder({Key? key, required this.adminName});

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final TextEditingController tanggalPemesananController =
      TextEditingController();
  final TextEditingController tanggalSampaiController = TextEditingController();
  final TextEditingController namaVendorController = TextEditingController();
  final TextEditingController namaPemesanController = TextEditingController();
  OrderServices _OrderServices = OrderServices();
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();

    tanggalPemesananController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    namaPemesanController.text = widget.adminName;
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

      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
    if (picked != null && picked != controller.text) {


      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void addItem(Map<String, dynamic> newItem) {
    setState(() {
      items.add(newItem);
    });
  }

  void createOrder() async {

    Map<String, dynamic> orderData = {
      'Tanggal_pemesanan': tanggalPemesananController.text,
      'Tanggal_sampai': tanggalSampaiController.text,
      'Nama_Vendor': namaVendorController.text,
      'Nama_Pemesan': namaPemesanController.text,
      'items': items,
    };


    if (orderData.values
            .any((element) => element == null || element.toString().isEmpty) ||
        items.isEmpty) {
      print('All fields must be filled and there must be an item');
      errorSnackBar(
          context, 'Semua kolom harus diisi dan harus ada item');
      return;
    }

    print(orderData);


    var response = await _OrderServices.createOrder(orderData);
    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 201) {

      print('Item added successfully');
      
      
      tanggalSampaiController.clear();
      namaVendorController.clear();
      
      setState(() {
        items.clear();
      });
      successSnackBar(context, 'Item added successfully');
    } else if (response.statusCode == 400) {

      print('Bad request: ${response.body}');

    } else if (response.statusCode == 422) {

      print('Unprocessable entity: ${response.body}');

    } else {

      print('Unexpected error occurred: ${response.body}');

    }
  }

void openItemSelectionScreen() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseItemOrder(),
      ),
    );
    if (newItem != null) {
      String customId = newItem['custom_id'];
      Map<String, dynamic>? existingItem = items.firstWhere(
        (item) => item['custom_id'] == customId,
        orElse: () => {},
      );
      print(existingItem);

      if (existingItem.isNotEmpty) {
        bool shouldReplace = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Duplicate Item'),
              content: Text(
                  'There is the same item in the item list with id "$customId".\nWould you like to change the quantity from ${existingItem['Quantity_ordered']} to ${newItem['Quantity_ordered']}?'),
              actions: [
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );

        if (shouldReplace) {
          setState(() {
            items.remove(existingItem);
            addItem(newItem as Map<String, dynamic>);
          });
        }
      } else {
        addItem(newItem as Map<String, dynamic>);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Form"),
        backgroundColor: Color(0xFF52E9AA),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: tanggalPemesananController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Tanggal Pemesanan",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  // suffixIcon: IconButton(
                  //   icon: Icon(Icons.calendar_today, color: Color(0xFF52E9AA)),
                  //   onPressed: () => _selectDate(context, tanggalPemesananController),

                  // ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: tanggalSampaiController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Tanggal Sampai",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: Color(0xFF52E9AA)),
                    onPressed: () =>
                        _selectDate(context, tanggalSampaiController),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: namaVendorController,
                decoration: InputDecoration(
                  labelText: "Nama Vendor",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: namaPemesanController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Nama Pemesan",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "Items",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                height: 200.0,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(item['custom_id']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${item['name']}'),
                            Text('Brand: ${item['brand']}'),
                            Text(
                                'Quantity Ordered: ${item['Quantity_ordered']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text(
                                      'Are you sure you want to delete item with name ' +
                                          items[index]['name'].toString() +
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
                                          items.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: openItemSelectionScreen,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  "Add Item",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: items.isEmpty ? null : createOrder,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: items.isEmpty ? Colors.grey : Colors.green,
                ),
                child: Text(
                  "Create Order",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
