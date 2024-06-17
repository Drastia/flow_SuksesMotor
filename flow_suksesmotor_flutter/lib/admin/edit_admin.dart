import 'package:flow_suksesmotor/admin/admin_accountlist.dart';
import 'package:flow_suksesmotor/services/admin_auth_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flutter/material.dart';

class EditAdmin extends StatefulWidget {
  final Map<String, dynamic> selectedAdmin;
  const EditAdmin({Key? key, required this.selectedAdmin}) : super(key: key);
  @override
  State<EditAdmin> createState() => _EditAdminState();
}

class _EditAdminState extends State<EditAdmin> {
  TextEditingController adminnameController = TextEditingController();
  TextEditingController adminusernameController = TextEditingController();

   @override
  void initState() {
    super.initState();
    // Set initial values in text fields based on selected item data
    adminnameController.text = widget.selectedAdmin['admin_name'];
    adminusernameController.text = widget.selectedAdmin['admin_username'];
    
  }

  void _updateAdmin() async {
  Map<String, dynamic> updatedData = {
    'admin_name': adminnameController.text,
    'admin_username': adminusernameController.text,
   
  };

  try {
    var response = await AuthServices().updateAdmin(
        widget.selectedAdmin['id'], updatedData);

    if (response.statusCode == 200) {
      // Item updated successfully
      print('Item updated successfully');
      // You can add code here to show a success message or navigate to another screen
      successSnackBar(context, 'Item updated successfully');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListAdmin()),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Admin'),
          backgroundColor: Color(0xFF52E9AA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: adminnameController,
              decoration: InputDecoration(
                  labelText: 'Nama Admin', hintText: 'harus diisi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),),
                  
            ),
            SizedBox(height: 20),
            TextField(
              controller: adminusernameController,
              decoration: InputDecoration(
                  labelText: 'Username Admin', hintText: 'harus diisi',
                  
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
              onPressed: _updateAdmin,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: Text('Update', style: TextStyle(color: Colors.white)),
            ),
          ),
          ],
        ),
      ),
    );
  }
}