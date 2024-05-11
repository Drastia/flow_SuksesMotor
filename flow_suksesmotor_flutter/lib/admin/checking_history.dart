import 'package:flutter/material.dart';


class CheckingHistory extends StatefulWidget {
  @override
  _CheckingHistoryState createState() => _CheckingHistoryState();
}

class _CheckingHistoryState extends State<CheckingHistory> {
  // final ItemServices _itemServices = ItemServices();
  List<Map<String, dynamic>> _Users = [
    {"id": 1, "nama": "Adit", "age": 23},
    {"id": 2, "nama": "Acay", "age": 19},
    {"id": 3, "nama": "Agon", "age": 25}
  ];
  // List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> selectedRows = [];
  // bool isItemSelected = false;
  // TextEditingController _searchController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    List<Widget> userWidgets = _Users.map((user) => Container(
      padding: const EdgeInsets.all(8), // Menambahkan padding untuk estetika
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${user["nama"]}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Menampilkan nama user dari _Users
          SizedBox(height: 5), // Menambahkan sedikit ruang antara teks
          Text('Status: '), // Status Barang apakah cocok dengan barang yang telah di order
          Text('Tanggal: ${DateTime.now().toString().substring(0, 10)}'), // Format tanggal: YYYY-MM-DD
          Text('Waktu: ${DateTime.now().toString().substring(11)}'), // Waktu saat item ini dibangun
        ],
      ),
    )).toList();

    return Scaffold(
      appBar: AppBar(title: Text("List Pengecekan")),
      body: SingleChildScrollView(
        child: ExpansionPanelList.radio(
          children: userWidgets.map((widget) => ExpansionPanelRadio(
            value: widget, 
            headerBuilder: (BuildContext context, bool isExpanded) => ListTile(
              title: Text("Kode Barang"), // Anda bisa memodifikasi ini sesuai dengan data yang relevan
            ), 
            body: widget,
          )).toList()
        ),
      ),
    );
  }
}
