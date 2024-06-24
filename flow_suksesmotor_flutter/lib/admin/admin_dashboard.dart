import 'package:flow_suksesmotor/admin/add_item.dart';
import 'package:flow_suksesmotor/admin/add_order.dart';
import 'package:flow_suksesmotor/admin/history_order.dart';
import 'package:flow_suksesmotor/admin/initial_accountlist.dart';
import 'package:flow_suksesmotor/admin/list_item.dart';
import 'package:flow_suksesmotor/admin/list_order.dart';
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

class AdminDashboard extends StatelessWidget {
  final String adminName; 
  AdminDashboard({Key? key, required this.adminName});

  
  

  @override
  Widget build(BuildContext context) {
    final List<GridItemData> gridItems = [
    GridItemData(
      logo: Image.asset('images/add_user.png', width: 100),
      name: 'Register User',
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      },
    ),
    GridItemData(
      logo: Image.asset('images/list_user.png', width: 100),
      name: 'list User',
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InitialAccountList()),
        );
      },
    ),
    
    GridItemData(
      logo: Image.asset('images/add_item.png', width: 100),
      name: 'Add Item',
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddItem()),
        );
      },
    ),
    GridItemData(
      logo: Image.asset('images/list_item.png', width: 100),
      name: 'Item List',
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListItem()),
        );
      },
    ),
    GridItemData(
      logo: Image.asset('images/add_order.png', width: 100),
      name: 'Add Order',
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddOrder(adminName: adminName)),
        );
      },
    ),
    GridItemData(
      logo: Image.asset('images/list_order.png', width: 100),
      name: 'List Order',
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListOrders()),
        );
      },
    ),
    GridItemData(
      logo: Image.asset('images/order_history.png', width: 100),
      name: 'History Order',
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryOrders()),
        );
      },
    ),
    GridItemData(
      logo: Icon(Icons.logout, size: 100),
      name: 'Logout',
      onTap: (BuildContext context) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InitialScreen()),
        );
      },
    ),
    
   
    
  ];
    return Scaffold(
      body: Stack(
        children: <Widget>[
          dashBg,
          content(context, gridItems), 
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
                    Color(0xFF7DE8FF),
                    Color(0xFFA0EAD8),
                    Color(0xFF67FFC5),
                    Color(0xFF0DFF99),
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

  Widget content(BuildContext context, List<GridItemData> gridItems) => Container(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: <Widget>[
            header,
            grid(context, gridItems), 
          ],
        ),
      );

  Widget get header => ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
        title: Text(
          adminName,
          style: TextStyle(color: Colors.black, fontSize: 30,fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.deepPurple),
        ),
      );

   Widget grid(BuildContext context, List<GridItemData> gridItems) => Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 16),
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: GridView.count(
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
        ),
      );
}
