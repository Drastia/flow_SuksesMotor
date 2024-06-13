import 'package:flutter/material.dart';

class CheckingHistory extends StatefulWidget {
  @override
  _CheckingHistoryState createState() => _CheckingHistoryState();
}

class _CheckingHistoryState extends State<CheckingHistory> {
  List<Map<String, dynamic>> _users = [
    {"id": 1, "nama": "Adit"},
    {"id": 2, "nama": "Acay"},
    {"id": 3, "nama": "Agon"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Pengecekan"),
        backgroundColor: Color(0xFF52E9AA),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionPanelList.radio(
            children: _users.map<ExpansionPanelRadio>((user) {
              String formattedDate = DateTime.now().toString().substring(0, 10);
              String formattedTime = DateTime.now().toString().substring(11);

              return ExpansionPanelRadio(
                value: user["id"].toString(),
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(user["nama"]),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status: Active", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text("Tanggal: $formattedDate", style: TextStyle(color: Colors.grey[700])),
                      Text("Waktu: $formattedTime", style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
