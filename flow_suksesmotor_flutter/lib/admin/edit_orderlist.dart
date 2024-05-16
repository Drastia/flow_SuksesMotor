import 'package:flow_suksesmotor/admin/list_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow_suksesmotor/services/order_services.dart'; // Import your order_services.dart file

class EditOrderList extends StatefulWidget {
  final int ID_pemesanan;
  final String Nama_Vendor;
  final String Nama_Pemesan;
  final String Tanggal_pemesanan;
  final String Tanggal_sampai;

  EditOrderList({
    required this.ID_pemesanan,
    required this.Nama_Vendor,
    required this.Nama_Pemesan,
    required this.Tanggal_pemesanan,
    required this.Tanggal_sampai,
  });

  @override
  _EditOrderListState createState() => _EditOrderListState();
}

class _EditOrderListState extends State<EditOrderList> {
  
  final TextEditingController vendorController = TextEditingController();
  final TextEditingController pemesanController = TextEditingController();
  final TextEditingController tanggalPemesananController = TextEditingController();
  final TextEditingController tanggalSampaiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with passed values
    vendorController.text = widget.Nama_Vendor;
    pemesanController.text = widget.Nama_Pemesan;
    tanggalPemesananController.text = widget.Tanggal_pemesanan;
    tanggalSampaiController.text = widget.Tanggal_sampai;
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != controller.text) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitEdit() async {
    // Prepare order data to update
    Map<String, dynamic> orderData = {
      'Nama_Vendor': vendorController.text,
      'Nama_Pemesan': pemesanController.text,
      'Tanggal_pemesanan': tanggalPemesananController.text,
      'Tanggal_sampai': tanggalSampaiController.text,
    };

    // Call the updateOrder function
    try {
      await OrderServices().updateOrder(widget.ID_pemesanan, orderData);
      // Handle success
      // For example, navigate back to previous screen
      
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListOrders()),
        );

    } catch (e) {
      // Handle error
      print('Error updating order: $e');
      // Show error dialog or snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 350,
                child: TextField(
                  controller: vendorController,
                  decoration: InputDecoration(
                    labelText: 'Vendor',
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: pemesanController,
                  decoration: InputDecoration(
                    labelText: 'Pemesan',
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: tanggalPemesananController,
                  readOnly: true,
                  onTap: () {
                    _selectDate(context, tanggalPemesananController);
                  },
                  decoration: InputDecoration(
                    labelText: 'Tanggal Pemesanan',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: tanggalSampaiController,
                  readOnly: true,
                  onTap: () {
                    _selectDate(context, tanggalSampaiController);
                  },
                  decoration: InputDecoration(
                    labelText: 'Tanggal Sampai',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitEdit, // Call _submitEdit function
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: Text(
                  'Submit Edit',
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
