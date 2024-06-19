import 'package:flow_suksesmotor/admin/edit_admin.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/admin_auth_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';


class ListAdmin extends StatefulWidget {
  @override
  _ListAdminState createState() => _ListAdminState();
}

class _ListAdminState extends State<ListAdmin> {
  
  List<Map<String, dynamic>> _admins = [];
  List<Map<String, dynamic>> selectedRows = [];
  bool isadminSelected = false;

void fetchAdmin() async {
    try {
      var fetchedItems = await AuthServices().fetchAdmin();
      setState(() {
        _admins = fetchedItems.cast<Map<String, dynamic>>();
        print(_admins);
      });
    } catch (error) {
      print('Error fetching items: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchAdmin();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _admins.length,
              itemBuilder: (BuildContext context, int index) {
                var admin = _admins[index];
                bool isSelected = selectedRows.contains(admin);

                return Card(
                  color: isSelected ? Colors.green[300] : null,
                  child: ListTile(
                    onTap: () {
                      _handleRowSelection(admin);
                    },
                    title: Text('${admin['admin_name']}'),
                    subtitle: Text('${admin['admin_username']}')
                  ),
                );
              },
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isadminSelected
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditAdmin(selectedAdmin: selectedRows.first)),
                        );
                      }
                    : null,
                child: Text('Edit', style: TextStyle(color: Colors.white)),
                style: isadminSelected
                    ? ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      )
                    : ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue.withOpacity(0.5)),
                      ),
              ),
              ElevatedButton(
                onPressed: isadminSelected ? () =>  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete admin account ' + selectedRows[0]['admin_name'] + '?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteSelectedadmins();
              },
            ),
          ],
        );
      },
    ) : null,
                
                child: Text('Delete', style: TextStyle(color: Colors.white)),
                style: isadminSelected
                    ? ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      )
                    : ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red.withOpacity(0.5)),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  

  void _handleRowSelection(Map<String, dynamic> admin) {
    setState(() {
      if (selectedRows.contains(admin)) {
        selectedRows.remove(admin);
      } else {
        selectedRows.clear();
        selectedRows.add(admin);
        print(admin);
      }
      isadminSelected = selectedRows.isNotEmpty;
    });
  }

  Future<void> _deleteSelectedadmins() async {
   
    for (var admin in selectedRows) {
      var adminId = admin['id'];
      
      await AuthServices().deleteAdmin(adminId);
      successSnackBar(context,
        'Akun admin dengan ID $adminId berhasil dihapus!');
    }

    
    fetchAdmin();
    Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListAdmin()),
        );
    setState(() {
      selectedRows.clear();
      isadminSelected = false;
    });
  }
}
