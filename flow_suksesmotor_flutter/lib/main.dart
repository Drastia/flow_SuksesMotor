import 'package:flow_suksesmotor/admin/add_order.dart';
import 'package:flow_suksesmotor/admin/admin_dashboard.dart';
import 'package:flow_suksesmotor/admin/choose_order_item.dart';
import 'package:flow_suksesmotor/admin/initial_accountlist.dart';
import 'package:flow_suksesmotor/admin/list_item.dart';
import 'package:flow_suksesmotor/admin/list_order.dart';
import 'package:flow_suksesmotor/admin/order_item.dart';
import 'package:flow_suksesmotor/admin/registerScreen.dart';
import 'package:flow_suksesmotor/admin/worker_accountlist.dart';
import 'package:flow_suksesmotor/worker/worker_dashboard.dart';
import 'package:flow_suksesmotor/worker/worker_order_list.dart';
import 'package:flutter/material.dart';
import 'screen/test.dart';
import 'screen/splashscreen.dart';
import 'admin/adminregister.dart';
import 'admin/workerregister.dart';
import 'screen/adminlogin.dart';
import 'screen/workerlogin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: SplashScreen(),
      //home: ListOrders(),
      //home: OrderItem(),
      //home: ListWorker(),
      //home: InitialAccountList(),
      //home: RegisterScreen(),
      //home:AdminDashboard(adminName: 'Rivaldo')
      home: WorkerDashboard(workerName: 'Demo11')
      //home: WorkerOrderList(workerName: 'Demo11')
      
    );
  }
}


