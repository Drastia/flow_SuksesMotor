import 'package:flow_suksesmotor/admin/add_item.dart';
import 'package:flow_suksesmotor/admin/add_order.dart';
import 'package:flow_suksesmotor/admin/admin_dashboard.dart';
import 'package:flow_suksesmotor/admin/choose_order_item.dart';
import 'package:flow_suksesmotor/admin/initial_accountlist.dart';
import 'package:flow_suksesmotor/admin/list_item.dart';
import 'package:flow_suksesmotor/admin/list_order.dart';
import 'package:flutter/services.dart';
import 'package:flow_suksesmotor/admin/registerScreen.dart';
import 'package:flow_suksesmotor/admin/worker_accountlist.dart';
import 'package:flow_suksesmotor/worker/OCR_scanner.dart';
import 'package:flow_suksesmotor/worker/worker_dashboard.dart';
import 'package:flow_suksesmotor/worker/worker_order_list.dart';
import 'package:flutter/material.dart';
import 'screen/splashscreen.dart';
import 'admin/adminregister.dart';
import 'admin/workerregister.dart';
import 'screen/adminlogin.dart';
import 'screen/workerlogin.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
 
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      //home: ListOrders(),
      //home: OrderItem(),
      //home: ListWorker(),
      //home: InitialAccountList(),
      //home: RegisterScreen(),
      //home:AdminDashboard(adminName: 'Rivaldo')
      //home: WorkerDashboard(workerName: 'Demo')
      //home: WorkerOrderList(workerName: 'Demo11')
      //home: OcrScanner(orderId: 1,workerName: 'Demo11',items: [],)
      //home:AddItem()
    );
  }
}


