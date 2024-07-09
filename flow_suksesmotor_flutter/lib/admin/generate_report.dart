import 'dart:convert';
import 'dart:io';
import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class ReportGenerator {
  static Future<Map<String, dynamic>> fetchReportData() async {
    final response = await http.get(Uri.parse(baseURL + 'report-data'));

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      throw Exception('Failed to load report data: ${response.body}');
    }
  }
  static String _formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}
  static Future<void> createPdf(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    final List<pw.Widget> contentWidgets = [
  pw.Column(
    children: [
      pw.Text(
        'Laporan Penggunaan Aplikasi Flow CV. Sukses Motor',
        style: pw.TextStyle(fontSize: 24),
        textAlign: pw.TextAlign.center,
      ),
      pw.SizedBox(height: 10), // Add space between the title and the date
      pw.Text(
       'Tanggal : ${_formatDate(DateTime.now())}',
      ),
    ],
  ),
  pw.SizedBox(height: 20),
];


    contentWidgets.addAll(_buildAdminAccountsSection('Pembuatan akun Admin', data['admin_table'] ?? []));
    contentWidgets.addAll(_buildWorkerAccountsSection('Pembuatan akun Worker', data['workers'] ?? []));

    contentWidgets.addAll(_buildAdminAccountsSection('Edit akun Admin', data['admin_table_edit'] ?? []));
    contentWidgets.addAll(_buildWorkerAccountsSection('Edit akun Worker', data['workers_edit'] ?? []));
 
    contentWidgets.addAll(_buildItemCreationSection('Pembuatan jenis barang', data['items'] ?? []));
    contentWidgets.addAll(_buildItemCreationSection('Edit jenis barang', data['items_edit'] ?? []));
    
    contentWidgets.addAll(_buildOrdersSection('Pembuatan Order dan Order List', data['orders'] ?? [], data['order_list'] ?? []));
    contentWidgets.addAll(_buildOrdersSection('Edit Order dan Order List', data['orders_edit'] ?? [], data['order_list_edit'] ?? []));

    contentWidgets.addAll(_buildAuditEditSection('Perubahan Detail Database', data['audit_edit'] ?? []));

    // Add pages
    pdf.addPage(
      pw.MultiPage(
        build: (context) => contentWidgets,
      ),
    );

    try {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        String reportPath = '${directory.path}/Report';
        String filePath = '$reportPath/Report_${_formatDate(DateTime.now())}.pdf';

        // Create the Report directory if it doesn't exist
        Directory reportDir = Directory(reportPath);
        if (!await reportDir.exists()) {
          await reportDir.create(recursive: true);
        }

        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());

        await openFile(file.path);
      } else {
        print('Failed to get directory');
      }
    } catch (e) {
      print('Error saving PDF: $e');
    }
  }

  static List<pw.Widget> _buildAuditEditSection(String title, List<dynamic>? AuditEditList) {
    if (AuditEditList == null || AuditEditList.isEmpty) {
      return [
        pw.Text(title, style: pw.TextStyle(fontSize: 18)),
        pw.SizedBox(height: 15),
        pw.Text('Tidak ada Perubahan'),
        pw.SizedBox(height: 25),
      ];
    }

    List<pw.Widget> widgets = [
      pw.Text(title, style: pw.TextStyle(fontSize: 18)),
      pw.SizedBox(height: 15),
    ];

    List<List<String>> tableData = [
      ['ID', 'table_name', 'field_name', 'old_value', 'new_value', 'changed_by', 'role'],
    ];

    for (var audit in AuditEditList) {
      tableData.add([
        audit['id'].toString(),
        audit['table_name'].toString(),
        audit['field_name'].toString(),
        audit['old_value'].toString(),
        audit['new_value'].toString(),
        audit['changed_by'].toString(),
        audit['role'].toString(),
      ]);
    }

    widgets.addAll(_paginateTableData(tableData));

    widgets.add(pw.SizedBox(height: 20));

    return widgets;
  }

  static List<pw.Widget> _buildAdminAccountsSection(String title, List<dynamic>? adminAccounts) {
    if (adminAccounts == null || adminAccounts.isEmpty) {
      return [
        pw.Text(title, style: pw.TextStyle(fontSize: 18)),
        pw.SizedBox(height: 15),
        pw.Text('Tidak ada Perubahan'),
        pw.SizedBox(height: 25),
      ];
    }

    List<pw.Widget> widgets = [
      pw.Text(title, style: pw.TextStyle(fontSize: 18)),
      pw.SizedBox(height: 15),
    ];

    List<List<String>> tableData = [
      ['ID', 'Nama Admin', 'Username'],
    ];

    for (var admin in adminAccounts) {
      tableData.add([
        admin['id'].toString(),
        admin['admin_name'].toString(),
        admin['admin_username'].toString(),
      ]);
    }

    widgets.addAll(_paginateTableData(tableData));

    widgets.add(pw.SizedBox(height: 20));

    return widgets;
  }

  static List<pw.Widget> _buildWorkerAccountsSection(String title, List<dynamic>? workerAccounts) {
    if (workerAccounts == null || workerAccounts.isEmpty) {
      return [
        pw.Text(title, style: pw.TextStyle(fontSize: 18)),
        pw.SizedBox(height: 15),
        pw.Text('Tidak ada Perubahan'),
        pw.SizedBox(height: 25),
      ];
    }

    List<pw.Widget> widgets = [
      pw.Text(title, style: pw.TextStyle(fontSize: 18)),
      pw.SizedBox(height: 15),
    ];

    List<List<String>> tableData = [
      ['ID', 'Nama Worker', 'Username'],
    ];

    for (var worker in workerAccounts) {
      tableData.add([
        worker['id'].toString(),
        worker['worker_name'].toString(),
        worker['worker_username'].toString(),
      ]);
    }

    widgets.addAll(_paginateTableData(tableData));

    widgets.add(pw.SizedBox(height: 20));

    return widgets;
  }

  static List<pw.Widget> _buildItemCreationSection(String title, List<dynamic>? items) {
    if (items == null || items.isEmpty) {
      return [
        pw.Text(title, style: pw.TextStyle(fontSize: 18)),
        pw.SizedBox(height: 15),
        pw.Text('Tidak ada Perubahan'),
        pw.SizedBox(height: 25),
      ];
    }

    List<pw.Widget> widgets = [
      pw.Text(title, style: pw.TextStyle(fontSize: 18)),
      pw.SizedBox(height: 15),
    ];

    List<List<String>> tableData = [
      ['ID', 'Nama Barang', 'Brand'],
    ];

    for (var item in items) {
      tableData.add([
        item['custom_id'].toString(),
        item['name'].toString(),
        item['brand'].toString(),
      ]);
    }

    widgets.addAll(_paginateTableData(tableData));

    widgets.add(pw.SizedBox(height: 20));

    return widgets;
  }

  static List<pw.Widget> _buildOrdersSection(String title, List<dynamic>? orders, List<dynamic>? orderList) {
    if ((orders == null || orders.isEmpty) && (orderList == null || orderList.isEmpty)) {
      return [
        pw.Text(title, style: pw.TextStyle(fontSize: 18)),
        pw.SizedBox(height: 15),
        pw.Text('Tidak ada Perubahan pada hari ini'),
        pw.SizedBox(height: 25),
      ];
    }

    List<pw.Widget> orderWidgets = [
      pw.Text(title, style: pw.TextStyle(fontSize: 18)),
      pw.SizedBox(height: 15),
    ];

    for (var order in orders ?? []) {
      List<List<String>> orderTableData = [
        ['Order', 'tanggal_pemesanan', 'tanggal_sampai', 'nama_vendor', 'nama_pemesan', 'checked'],
      ];

      orderTableData.add([
        order['ID_pemesanan'].toString(),
        order['tanggal_pemesanan'].toString(),
        order['tanggal_sampai'].toString(),
        order['nama_vendor'].toString(),
        order['nama_pemesan'].toString(),
        order['checked'].toString(),
      ]);

      orderWidgets.addAll(_paginateTableData(orderTableData));

      List<dynamic> orderItems = orderList?.where((item) => item['ID_pemesanan'] == order['ID_pemesanan']).toList() ?? [];
      if (orderItems.isNotEmpty) {
        List<List<String>> orderItemList = [
          ['Item', 'name', 'brand', 'Quantity_ordered', 'Incoming_Quantity', 'checker_barang', 'ismatch'],
        ];

        for (var item in orderItems) {
          orderItemList.add([
            item['custom_id'].toString(),
            item['name'].toString(),
            item['brand'].toString(),
            item['Quantity_ordered'].toString(),
            item['Incoming_Quantity'].toString(),
            item['checker_barang'].toString(),
            item['ismatch'].toString(),
          ]);
        }

        orderWidgets.addAll(_paginateTableData(orderItemList));
      }

      orderWidgets.add(pw.SizedBox(height: 15));
    }

    orderWidgets.add(pw.SizedBox(height: 20));

    return orderWidgets;
  }

  static List<pw.Widget> _paginateTableData(List<List<String>> tableData) {
    List<pw.Widget> paginatedWidgets = [];
    int rowsPerPage = 20; // Adjust the number of rows per page as needed
    List<String> headerRow = tableData[0]; // Store the header row

    for (int i = 1; i < tableData.length; i += rowsPerPage) {
        paginatedWidgets.add(
            pw.Table.fromTextArray(
                context: null,
                headerCount: 1, // Include header for each paginated section
                data: [
                    headerRow,
                    ...tableData.sublist(i, i + rowsPerPage > tableData.length ? tableData.length : i + rowsPerPage)
                ],
                border: pw.TableBorder.all(width: 1.0, color: PdfColors.grey),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                cellStyle: pw.TextStyle(fontSize: 10),
                cellAlignment: pw.Alignment.center,
            ),
        );
        paginatedWidgets.add(pw.SizedBox(height: 10));
    }

    return paginatedWidgets;
}

  static Future<void> openFile(String path) async {
    await OpenFilex.open(path);
  }

  static Future<void> generateReport() async {
    try {
      print('Fetching report data...');
      final data = await fetchReportData();
      print('Data fetched: $data');
      print('Creating PDF...');
      await createPdf(data);
      print('PDF created successfully.');
    } catch (e) {
      print('Error generating report: $e');
    
    }
  }
}
