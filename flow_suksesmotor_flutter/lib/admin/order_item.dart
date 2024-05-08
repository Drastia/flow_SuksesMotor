import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/item_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({Key? key}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  TextEditingController customIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController brandController = TextEditingController();

  // ItemServices _itemServices = ItemServices();

  void OrderItem() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: customIdController,
                    decoration: InputDecoration(
                      labelText: 'Kode Barang', hintText: 'min 6 huruf/angka'
                    ),
                    onChanged: (value) {
                      customIdController.value = customIdController.value.copyWith(
                        text: value.toUpperCase(), // Convert value to uppercase
                        selection: TextSelection.collapsed(offset: value.length), // Maintain cursor position
                      );
                    },
                  ),
                ),
                SizedBox(width: 8), // Spacer between the two text fields
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    decoration: InputDecoration(
                      labelText: 'Jumlah Barang', hintText: 'harus diisi'
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Nama Barang', hintText: 'min 6 huruf/angka'),
            ),
            TextField(
              controller: brandController,
              decoration: InputDecoration(
                  labelText: 'Merk Barang', hintText: 'harus diisi'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: OrderItem,
              child: Text('Order Item'),
            ),
          ],
        ),
      ),
    );
  }
}
