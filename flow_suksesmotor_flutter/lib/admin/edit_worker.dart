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
  TextEditingController workerpasswordController = TextEditingController();
  bool _isPasswordInvisible = false;
   @override
  void initState() {
    super.initState();
    // Set initial values in text fields based on selected item data
    workernameController.text = widget.selectedWorker['worker_name'];
    workerusernameController.text = widget.selectedWorker['worker_username'];
    workerpasswordController.text = '';
    
  }

  void _updateWorker() async {
  Map<String, dynamic> updatedData = {
    'worker_name': workernameController.text,
    'worker_username': workerusernameController.text,
   
  };
  if (workerpasswordController.text.isNotEmpty) {
    updatedData['worker_password'] = workerpasswordController.text;
  }

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
        title: Text('Update Worker'),
          backgroundColor: Color(0xFF52E9AA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: workernameController,
              decoration: InputDecoration(
                  labelText: 'Nama Worker', hintText: 'harus diisi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),),
                  
            ),
            SizedBox(height: 20),
            TextField(
              controller: workerusernameController,
              decoration: InputDecoration(
                  labelText: 'Username Worker', hintText: 'harus diisi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: workerpasswordController,
              obscureText: !_isPasswordInvisible, 
              decoration: InputDecoration(
                  labelText: 'Password Worker', hintText: 'Leave blank to keep the password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                   suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordInvisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordInvisible = !_isPasswordInvisible;
                      });
                    },
                  ),
                  ),
            ),
            SizedBox(height: 20),
            Center(
            child: ElevatedButton(
              onPressed: _updateWorker,
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