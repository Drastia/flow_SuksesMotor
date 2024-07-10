import 'package:flow_suksesmotor/admin/read_orderitems.dart';
import 'package:flow_suksesmotor/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  final String adminName;
  CalendarPage({ required this.adminName});
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class Event {
  final DateTime date;
  final int count;

  Event(this.date, this.count);

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      DateTime.parse(map['date']),
      map['count'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Event(date: $date, count: $count)';
  }
}

class Order {
  final int id;
  final DateTime tanggalPemesanan;
  final DateTime tanggalSampai;
  final String namaVendor;
  final String namaPemesan;
  final String checked;

  Order({
    required this.id,
    required this.tanggalPemesanan,
    required this.tanggalSampai,
    required this.namaVendor,
    required this.namaPemesan,
    required this.checked,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['ID_pemesanan'],
      tanggalPemesanan: DateTime.parse(map['tanggal_pemesanan']),
      tanggalSampai: DateTime.parse(map['tanggal_sampai']),
      namaVendor: map['nama_vendor'] ?? '',
      namaPemesan: map['nama_pemesan'] ?? '',
      checked: map['checked'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, tanggalPemesanan: $tanggalPemesanan, tanggalSampai: $tanggalSampai, namaVendor: $namaVendor, namaPemesan: $namaPemesan, checked: $checked)';
  }
}

Widget _buildCheckIcon(Order order) {
  if (order.checked == '') {
    return SizedBox(width: 24);
  } else if (order.checked == 'true') {
    return Icon(Icons.check, color: Colors.green);
  } else {
    return Icon(Icons.clear, color: Colors.red);
  }
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Map<DateTime, List<Event>> _events = {};
  late List<Order> _ordersForSelectedDay = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final response =
          await http.get(Uri.parse(baseURL + 'orders/countOrdersByDate'));
      if (response.statusCode == 200) {
        Iterable data = json.decode(response.body);
        print('Fetched data: $data');
        List<Event> events = data.map((e) => Event.fromMap(e)).toList();
        print('Parsed events: $events');
        // Convert the list of events into a map grouping by DateTime
        Map<DateTime, List<Event>> eventsMap = {};
        events.forEach((event) {
          DateTime dateWithoutTime =
              DateTime(event.date.year, event.date.month, event.date.day);
          if (eventsMap[dateWithoutTime] == null) {
            eventsMap[dateWithoutTime] = [];
          }
          eventsMap[dateWithoutTime]!.add(event);
        });

        setState(() {
          _events = eventsMap;
          print('Events map: $_events');
        });
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  Future<void> _fetchOrdersForSelectedDay(DateTime selectedDay) async {
    try {
      final formattedDate =
          "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
      final response = await http
          .get(Uri.parse(baseURL + 'orders/getOrdersByDate/$formattedDate'));
      if (response.statusCode == 200) {
        Iterable data = json.decode(response.body);
        print('Fetched orders for selected day: $data');
        List<Order> orders = data.map((e) => Order.fromMap(e)).toList();
        setState(() {
          _ordersForSelectedDay = orders;
          print('Orders for selected day: $_ordersForSelectedDay');
        });
      } else {
        throw Exception(
            'Failed to load orders for selected day: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders for selected day: $e');
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    DateTime dayWithoutTime = DateTime(day.year, day.month, day.day);
    return _events[dayWithoutTime] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order Calendar'),
          backgroundColor: Color(0xFF52E9AA),
        ),
        body: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              daysOfWeekHeight: 40,
              rowHeight: 60,
              weekendDays: [DateTime.saturday, DateTime.sunday],
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  final eventList = events as List<Event>;
                  print('Day: $day, Events: $eventList');
                  if (eventList.isNotEmpty) {
                    int totalEvents =
                        eventList.fold(0, (sum, event) => sum + event.count);

                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.rectangle,
                        ),
                        width: 16.0,
                        height: 16.0,
                        child: Center(
                          child: Text(
                            '$totalEvents',
                            style: TextStyle().copyWith(
                              color: Colors.white,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
                todayBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Container(
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Container(
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _fetchOrdersForSelectedDay(selectedDay);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: _getEventsForDay,
              calendarStyle: CalendarStyle(
                todayTextStyle: TextStyle(fontSize: 12, color: Colors.white),
                selectedTextStyle: TextStyle(fontSize: 12, color: Colors.white),
                markersAlignment: Alignment.bottomRight,
                todayDecoration: BoxDecoration(
                  color: Colors.blue[300],
                  shape: BoxShape.rectangle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.lightGreen,
                  shape: BoxShape.rectangle,
                ),
                defaultTextStyle: TextStyle(fontSize: 12),
                weekendTextStyle: TextStyle(
                  color: Colors.green,
                  fontSize: 12.0,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
              ),
            ),
           Expanded(
  child: SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 8.0),
        ..._ordersForSelectedDay.map(
          (order) {
            // Determine the box color based on the conditions
            Color boxColor = Colors.white;
            if (DateFormat('yyyy-MM-dd').format(order.tanggalPemesanan) == DateFormat('yyyy-MM-dd').format(_selectedDay!)) {
              boxColor = Color.fromARGB(255, 255, 246, 161); // Tanggal Pemesanan matches the selected day
            }
            if (DateFormat('yyyy-MM-dd').format(order.tanggalSampai) == DateFormat('yyyy-MM-dd').format(_selectedDay!)) {
              boxColor = const Color.fromARGB(255, 188, 225, 255); // Tanggal Sampai matches the selected day
            }
            if (DateFormat('yyyy-MM-dd').format(order.tanggalSampai) == DateFormat('yyyy-MM-dd').format(order.tanggalPemesanan)) {
              boxColor = Color.fromARGB(255, 114, 255, 189); // Tanggal Sampai matches the selected day
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReadOrderItems(
                                              orderId: order.id, adminName: widget.adminName),
                                        ),
                                      );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                    color: boxColor,
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ID pemesanan : ${order.id}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildCheckIcon(order),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (DateFormat('yyyy-MM-dd').format(order.tanggalPemesanan) == DateFormat('yyyy-MM-dd').format(_selectedDay!))
                          Text('Tanggal Sampai: ${DateFormat('dd-MM-yyy').format(order.tanggalSampai)}'),
                        if (DateFormat('yyyy-MM-dd').format(order.tanggalSampai) == DateFormat('yyyy-MM-dd').format(_selectedDay!))
                          Text('Tanggal Pemesanan: ${DateFormat('dd-MM-yyy').format(order.tanggalPemesanan)}'),
                        Text('Nama Vendor: ${order.namaVendor}'),
                        Text('Nama Pemesan: ${order.namaPemesan}'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ),
  ),
),
          ],
        ));
  }
}
