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
      successSnackBar(context, 'Item added successfully');
    } else if (customIdController.text.isEmpty ||
        nameController.text.isEmpty ||
        brandController.text.isEmpty) {
      errorSnackBar(context, 'Please fill in all fields');
      return;
    } else {
      print('Error adding item: ${response.statusCode}');
      errorSnackBar(context,
          'Barang sudah ada karena terdapat kesamaan ID item atau format pengisian form yang salah, ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('Add Item'),

          automaticallyImplyLeading: true,

          backgroundColor: Color(0xFF52E9AA),
          elevation: 0,

        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: customIdController,
                decoration: InputDecoration(
                  labelText: 'ID barang',
                  hintText: 'min 6 huruf/angka',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                ),
                onChanged: (value) {
                  customIdController.value = customIdController.value.copyWith(
                    text: value.toUpperCase(),
                    selection: TextSelection.collapsed(offset: value.length),
                  );
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama barang',
                  hintText: 'min 6 huruf/angka',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: brandController,
                decoration: InputDecoration(
                  labelText: 'Merk barang',
                  hintText: 'harus diisi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    
                  ),
                  child: ElevatedButton(
                    onPressed: addItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      
                 
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Add Item'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  
  }
}
