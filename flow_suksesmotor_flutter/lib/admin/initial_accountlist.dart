import 'package:flow_suksesmotor/admin/admin_accountlist.dart';
import 'package:flow_suksesmotor/admin/adminregister.dart';
import 'package:flow_suksesmotor/admin/worker_accountlist.dart';
import 'package:flow_suksesmotor/admin/workerregister.dart';
import 'package:flutter/material.dart';


class InitialAccountList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Initial Account list Screen'),
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo widget
            Image.asset(
              'images/flow_logo.png',
              width: 100,
              height: 100,
              // Adjust width and height as per your logo size
            ),
            SizedBox(height: 50),
            // Admin button
            SizedBox(
              width: 200, // Adjust button width
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to admin login screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListAdmin()),
                  );
                },
                child: Text('Admin'),
              ),
            ),
            SizedBox(height: 20),
            // Worker button
            SizedBox(
              width: 200, // Adjust button width
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to worker login screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListWorker()),
                  );
                },
                child: Text('Worker'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
