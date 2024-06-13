import 'package:flow_suksesmotor/services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/item_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';
import 'choose_order_item.dart'; // Import the ChooseItemOrder screen
import 'package:intl/intl.dart';

class AddOrder extends StatefulWidget {
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

  void addItem(Map<String, dynamic> newItem) {
    setState(() {
      items.add(newItem);
    });
  }

  void createOrder() async {
  // Prepare the order data
  Map<String, dynamic> orderData = {
    'Tanggal_pemesanan': tanggalPemesananController.text,
    'Tanggal_sampai': tanggalSampaiController.text,
    'Nama_Vendor': namaVendorController.text,
    'Nama_Pemesan': namaPemesanController.text,
    'items': items,
  };

  // Check if orderData is empty or items list is empty
  if (orderData.values.any((element) => element == null || element.toString().isEmpty) || items.isEmpty) {
    print('All fields must be filled and there must be an item');
    errorSnackBar(context, 'All fields must be filled and there must be an item');
    return;
  }

  print(orderData);
  
  // Make the API call if the data is valid
  var response = await _OrderServices.createOrder(orderData);
  print("Response status code: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode == 201) {
    // Item added successfully
    print('Item added successfully');
    // You can add code here to show a success message or navigate to another screen
    tanggalPemesananController.clear();
    tanggalSampaiController.clear();
    namaVendorController.clear();
    namaPemesanController.clear();
    setState(() {
      items.clear();
    });
    successSnackBar(context, 'Item added successfully');
  } else if (response.statusCode == 400) {
    // Bad request
    print('Bad request: ${response.body}');
    // You can add code here to show an error message or handle the failure
  } else if (response.statusCode == 422) {
    // Unprocessable Entity
    print('Unprocessable entity: ${response.body}');
    // You can add code here to show an error message or handle the failure
  } else {
    // Other error
    print('Unexpected error occurred: ${response.body}');
    // You can add code here to show an error message or handle the failure
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
      addItem(newItem as Map<String, dynamic>);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Form"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: tanggalPemesananController,
                decoration: InputDecoration(
                  labelText: "Tanggal Pemesanan",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () =>
                        _selectDate(context, tanggalPemesananController),
                  ),
                ),
              ),
              TextField(
                controller: tanggalSampaiController,
                decoration: InputDecoration(
                  labelText: "Tanggal Sampai",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () =>
                        _selectDate(context, tanggalSampaiController),
                  ),
                ),
              ),
              TextField(
                controller: namaVendorController,
                decoration: InputDecoration(labelText: "Nama Vendor"),
              ),
              TextField(
                controller: namaPemesanController,
                decoration: InputDecoration(labelText: "Nama Pemesan"),
              ),
              SizedBox(height: 16.0),
              Text("Items"),
              SizedBox(height: 8.0),
              Container(
                height: 200.0,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(item['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Custom ID: ${item['custom_id']}'),
                            Text('Brand: ${item['brand']}'),
                            Text(
                                'Quantity Ordered: ${item['Quantity_ordered']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Remove item from the list
                            setState(() {
                              items.removeAt(index);
                            });
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
                child: Text("Add Item"),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: createOrder,
                child: Text("Create Order"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
