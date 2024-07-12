import 'package:flow_suksesmotor/admin/list_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow_suksesmotor/services/order_services.dart'; 
import 'package:flow_suksesmotor/services/globals.dart';

class EditOrderList extends StatefulWidget {
  final String adminName;
  final int ID_pemesanan;
  final String Nama_Vendor;
  final String Nama_Pemesan;
  final String Tanggal_pemesanan;
  final String Tanggal_sampai;

  EditOrderList({
    required this.adminName,
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
    
    Map<String, dynamic> orderData = {
      'Nama_Vendor': vendorController.text,
      'Nama_Pemesan': pemesanController.text,
      'Tanggal_pemesanan': tanggalPemesananController.text,
      'Tanggal_sampai': tanggalSampaiController.text,
    };

    if (RegExp(r'^[a-zA-Z0-9- ]+$').hasMatch(vendorController.text)) {
        
      }else{
        errorSnackBar(context, 'Dont use symbols on Vendor Name');
        return;
      }
    try {
      await OrderServices().updateOrder(widget.ID_pemesanan, orderData, widget.adminName);
      
      
      
      Navigator.pop(context, widget.adminName);
      

    } catch (e) {
      
      print('Error updating order: $e');
      
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Edit Order'),
        backgroundColor: Color(0xFF52E9AA),
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 5.0),
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
                    onPressed: () => _selectDate(context, tanggalSampaiController),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: vendorController,
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
                controller: pemesanController,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitEdit,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: Text(
                  'Submit Edit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0), 
            ],
          ),
        ),
      ),
    ),
  );
}

  }

