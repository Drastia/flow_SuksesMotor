import 'package:flow_suksesmotor/admin/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/item_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';

class EditItem extends StatefulWidget {
  final Map<String, dynamic> selectedItem;
  const EditItem({Key? key, required this.selectedItem}) : super(key: key);
  
  @override
  _EditItemState createState() => _EditItemState();
}
  


class _EditItemState extends State<EditItem> {
  TextEditingController customIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController brandController = TextEditingController();

  ItemServices _itemServices = ItemServices();

  void _updateItem() async {
  Map<String, dynamic> updatedData = {
    'custom_id': customIdController.text,
    'name': nameController.text,
    'brand': brandController.text,
  };

  try {
    var response = await _itemServices.updateItem(
        widget.selectedItem['id'], updatedData);

    if (response.statusCode == 200) {
      // Item updated successfully
      print('Item updated successfully');
      // You can add code here to show a success message or navigate to another screen
      successSnackBar(context, 'Item updated successfully');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListItem()),
        );
    } else {
      // Error updating item
      print('Error updating item: ${response.statusCode}');
      errorSnackBar(context, 'Terdapat duplikasi antara ID Barang atau nama barang sehingga gagal');
    }
  } catch (error) {
    // Handle error
    print('Error updating item: $error');
    errorSnackBar(context, 'Tidak terhubung ke server atau error yang tidak diketahui');
  }
}

   @override
  void initState() {
    super.initState();
    // Set initial values in text fields based on selected item data
    customIdController.text = widget.selectedItem['custom_id'];
    nameController.text = widget.selectedItem['name'];
    brandController.text = widget.selectedItem['brand'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
          backgroundColor: Color(0xFF52E9AA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: customIdController,
              decoration: InputDecoration(
                  labelText: 'ID barang', hintText: 'min 6 huruf/angka',
                   border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),),
              onChanged: (value) {
                // Convert the value to uppercase and set it back to the controller
                customIdController.value = customIdController.value.copyWith(
                  text: value.toUpperCase(), // Convert value to uppercase
                  selection: TextSelection.collapsed( 
                      offset: value.length), // Maintain cursor position
                );
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Nama barang', hintText: 'min 6 huruf/angka',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),),
            ),
            SizedBox(height: 20),
            TextField(
              controller: brandController,
              decoration: InputDecoration(
                  labelText: 'merk barang', hintText: 'harus diisi',
                   border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
              onPressed: _updateItem,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: Text('Edit Item', style: TextStyle(color: Colors.white)),
            ),)
            
          ],
        ),
      ),
    );
  }
}
