import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/item_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController customIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController brandController = TextEditingController();

  ItemServices _itemServices = ItemServices();

  void addItem() async {
    Map<String, dynamic> data = {
      'custom_id': customIdController.text,
      'name': nameController.text,
      'brand': brandController.text,
    };

    var response = await _itemServices.addItem(data);
    if (response.statusCode == 201) {
      // Item added successfully
      print('Item added successfully');
      // You can add code here to show a success message or navigate to another screen
      successSnackBar(context, 'Item added successfully');
    } else if (customIdController.text.isEmpty ||
        nameController.text.isEmpty ||
        brandController.text.isEmpty) {
      // Show error snack bar if any field is empty
      errorSnackBar(context, 'Please fill in all fields');
      return;
    } else {
      // Error adding item
      print('Error adding item: ${response.statusCode}');
      errorSnackBar(context,
          'Item sudah ada karena terdapat kesamaan ID item atau Nama item, ${response.statusCode}');
      // You can add code here to show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('Add Item'),
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: customIdController,
                decoration: InputDecoration(
                    labelText: 'ID barang', hintText: 'min 6 huruf/angka'),
                onChanged: (value) {
                  // Convert the value to uppercase and set it back to the controller
                  customIdController.value = customIdController.value.copyWith(
                    text: value.toUpperCase(), // Convert value to uppercase
                    selection: TextSelection.collapsed(offset: value.length), // Maintain cursor position
                  );
                },
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Nama barang', hintText: 'min 6 huruf/angka'),
              ),
              TextField(
                controller: brandController,
                decoration: InputDecoration(
                    labelText: 'Merk barang', hintText: 'harus diisi'),
              ),
              SizedBox(height: 20),
              Center(  // Centering the button
                child: ElevatedButton(
                  onPressed: addItem,
                  child: Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,  // Sets the background color of the button
                    foregroundColor: Colors.white, // Sets the text color of the button
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Padding inside the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    elevation: 5, // Shadow elevation
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  
  }
}