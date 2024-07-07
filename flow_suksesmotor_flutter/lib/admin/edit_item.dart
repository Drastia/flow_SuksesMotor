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
    if (RegExp(r'^[a-zA-Z0-9]{6,}$').hasMatch(customIdController.text) &&
        RegExp(r'^[a-zA-Z0-9 ]{6,}$').hasMatch(nameController.text) &&
        RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(brandController.text)) {
    } else {
      errorSnackBar(context,
          'Tidak boleh menggunakan simbol di semua kolom dan Panjang ID dan nama pengguna harus lebih dari atau sama dengan 6 karakter.');
      return;
    }
    try {
      var response = await _itemServices.updateItem(
          widget.selectedItem['id'], updatedData);

      if (response.statusCode == 200) {
        print('Item updated successfully');

        successSnackBar(context, 'Item updated successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListItem()),
        );
      } else {
        print('Error updating item: ${response.statusCode}');
        errorSnackBar(context,
            'salah satu field dikosongkan atau ID dan Nama barang ada yang sama');
      }
    } catch (error) {
      print('Error updating item: $error');
      errorSnackBar(
          context, 'Tidak terhubung ke server atau error yang tidak diketahui');
    }
  }

  @override
  void initState() {
    super.initState();

    customIdController.text = widget.selectedItem['custom_id'];
    nameController.text = widget.selectedItem['name'];
    brandController.text = widget.selectedItem['brand'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
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
                labelText: 'ID barang',
                hintText: 'min 6 huruf/angka',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              ),
              onChanged: (value) {
                customIdController.value = customIdController.value.copyWith(
                  text: value.toUpperCase(),
                  selection: TextSelection.collapsed(offset: value.length),
                );
              },
            ),
            SizedBox(height: 20),
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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: brandController,
              decoration: InputDecoration(
                labelText: 'merk barang',
                hintText: 'harus diisi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _updateItem,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: Text('Edit Item', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
