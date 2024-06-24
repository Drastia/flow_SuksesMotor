import 'package:flow_suksesmotor/admin/adminregister.dart';
import 'package:flow_suksesmotor/admin/workerregister.dart';
import 'package:flutter/material.dart';


class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox.shrink(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/flow_logo.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 60, 
              width: 200, 
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => adminregister(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF52E9AA)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), 
                    ),
                  ),
                ),
                child: Text(
                  'Admin',
                  style: TextStyle(fontSize: 20), 
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 60, 
              width: 200, 
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => workerregister(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF52E9AA)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), 
                    ),
                  ),
                ),
                child: Text(
                  'Worker',
                  style: TextStyle(fontSize: 20), 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
