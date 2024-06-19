import 'package:flow_suksesmotor/admin/edit_worker.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/services/worker_auth_services.dart';
import 'package:flow_suksesmotor/services/globals.dart';

class ListWorker extends StatefulWidget {
  @override
  _ListWorkerState createState() => _ListWorkerState();
}

class _ListWorkerState extends State<ListWorker> {
  
  List<Map<String, dynamic>> _workers = [];
  List<Map<String, dynamic>> selectedRows = [];
  bool isworkerSelected = false;

void fetchWorker() async {
    try {
      var fetchedItems = await AuthServices().fetchWorker();
      setState(() {
        _workers = fetchedItems.cast<Map<String, dynamic>>();
      });
    } catch (error) {
      print('Error fetching items: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchWorker();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _workers.length,
              itemBuilder: (BuildContext context, int index) {
                var worker = _workers[index];
                bool isSelected = selectedRows.contains(worker);

                return Card(
                  color: isSelected ? Colors.green[300] : null,
                  child: ListTile(
                    onTap: () {
                      _handleRowSelection(worker);
                    },
                    title: Text('${worker['worker_name']}'),
                    subtitle: Text('${worker['worker_username']}')
                  ),
                );
              },
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isworkerSelected
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditWorker(selectedWorker: selectedRows.first)),
                        );
                      }
                    : null,
                child: Text('Edit', style: TextStyle(color: Colors.white)),
                style: isworkerSelected
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
                onPressed: isworkerSelected ? () => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete worker account ' + selectedRows[0]['worker_name'] + '?'),
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
                _deleteSelectedworkers();
              },
            ),
          ],
        );
      },
    ) : null,
                child: Text('Delete', style: TextStyle(color: Colors.white)),
                style: isworkerSelected
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

  void _handleRowSelection(Map<String, dynamic> worker) {
    setState(() {
      if (selectedRows.contains(worker)) {
        selectedRows.remove(worker);
      } else {
        selectedRows.clear();
        selectedRows.add(worker);
      }
      isworkerSelected = selectedRows.isNotEmpty;
    });
  }

  Future<void> _deleteSelectedworkers() async {
   
    for (var worker in selectedRows) {
      var workerId = worker['id'];
      
      await AuthServices().deleteWorker(workerId);
      successSnackBar(context,
        'Akun worker dengan ID $workerId berhasil dihapus!');
    }

    
    fetchWorker();
    Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListWorker()),
        );
    setState(() {
      selectedRows.clear();
      isworkerSelected = false;
    });
  }
}
