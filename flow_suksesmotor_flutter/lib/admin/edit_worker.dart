import 'package:flow_suksesmotor/admin/worker_accountlist.dart';
import 'package:flow_suksesmotor/services/worker_auth_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flutter/material.dart';

class EditWorker extends StatefulWidget {
  final Map<String, dynamic> selectedWorker;
  const EditWorker({Key? key, required this.selectedWorker}) : super(key: key);
  @override
  State<EditWorker> createState() => _EditWorkerState();
}

class _EditWorkerState extends State<EditWorker> {
  TextEditingController workernameController = TextEditingController();
  TextEditingController workerusernameController = TextEditingController();

   @override
  void initState() {
    super.initState();
    // Set initial values in text fields based on selected item data
    workernameController.text = widget.selectedWorker['worker_name'];
    workerusernameController.text = widget.selectedWorker['worker_username'];
    
  }

  void _updateWorker() async {
  Map<String, dynamic> updatedData = {
    'worker_name': workernameController.text,
    'worker_username': workerusernameController.text,
   
  };

  try {
    var response = await AuthServices().updateWorker(
        widget.selectedWorker['id'], updatedData);

    if (response.statusCode == 200) {
      // Item updated successfully
      print('Item updated successfully');
      // You can add code here to show a success message or navigate to another screen
      successSnackBar(context, 'Item updated successfully');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListWorker()),
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
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: workernameController,
              decoration: InputDecoration(
                  labelText: 'Nama Worker', hintText: 'harus diisi'),
            ),
            TextField(
              controller: workerusernameController,
              decoration: InputDecoration(
                  labelText: 'Username Worker', hintText: 'harus diisi'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateWorker,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}