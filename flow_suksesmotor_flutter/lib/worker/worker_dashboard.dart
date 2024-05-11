
import 'package:flow_suksesmotor/screen/initialscreen.dart';
import 'package:flutter/material.dart';
import 'package:flow_suksesmotor/admin/registerScreen.dart';

class GridItemData {
  final Widget logo;
  final String name;
  final void Function(BuildContext) onTap;

  GridItemData({
    required this.logo,
    required this.name,
    required this.onTap,
  });
}

class WorkerDashboard extends StatelessWidget {
  final String workerName; 
   WorkerDashboard({super.key, required this.workerName});

  final List<GridItemData> gridItems = [
    GridItemData(
      logo: FlutterLogo(size: 100),
      name: 'Scan Barang',
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      },
    ),
    GridItemData(
      logo: Icon(Icons.logout, size: 100),
      name: 'Check Order',
      onTap: (BuildContext context) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InitialScreen()),
        );
      },
    ),
    // Add more GridItemData objects for additional grid items
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
        children: <Widget>[
          dashBg,
          content(context), // Pass context to content method
        ],
      ),
    );
  }

  Widget get dashBg => Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0DFF99),
                    Color(0xFF67FFC5),
                    Color(0xFFA0EAD8),
                    Color(0xFF7DE8FF),
                    
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(color: Colors.transparent),
          ),
        ],
      );

  Widget content(BuildContext context) => Container(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: <Widget>[
            header,
            grid(context), // Pass context to grid method
          ],
        ),
      );

  Widget get header => ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
        title: Text(
          workerName,
          style: TextStyle(color: Colors.black, fontSize: 30,fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Worker Dashboard',
          style: TextStyle(color: Colors.deepPurple),
        ),
      );

  Widget grid(BuildContext context) => Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 16),
          child: Padding(
      padding: EdgeInsets.only(top: 30), 
      child:GridView.count(
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            crossAxisCount: 2,
            childAspectRatio: .90,
            children: List.generate(gridItems.length, (index) {
              return GestureDetector(
                onTap: () => gridItems[index].onTap(context),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        gridItems[index].logo,
                        Text(gridItems[index].name),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ));
}