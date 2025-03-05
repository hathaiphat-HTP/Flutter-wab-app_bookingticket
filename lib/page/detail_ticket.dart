import 'package:chapter4_cloud_firestore/main.dart';
import 'package:flutter/material.dart';

List<String> list = <String>[
  'ที่นั่งแถวที่ 1 เบาะที่ 1',
  'ที่นั่งแถวที่ 1 เบาะที่ 2',
  'ที่นั่งแถวที่ 1 เบาะที่ 3',
  'ที่นั่งแถวที่ 2 เบาะที่ 1',
  'ที่นั่งแถวที่ 2 เบาะที่ 2',
  'ที่นั่งแถวที่ 2 เบาะที่ 3',
];

class DetailTiclet extends StatefulWidget {
  String name;
  String id;
  String origin;
  String destination;
  String numticket;
  String selectedDate;

  DetailTiclet(this.name, this.id, this.origin, this.destination,
      this.selectedDate, this.numticket);


  @override
  _DetailTicletState createState() => _DetailTicletState();
}

class _DetailTicletState extends State<DetailTiclet> {
  TextEditingController _seat = TextEditingController();
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "ตารางการเดินทาง",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.green[900],
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      ),
                      color: Colors.green[900],
                    ),
                    child: Row(
                      children: [
                        Text(
                          "เที่ยวไป - ${widget.selectedDate} ".substring(0, 22),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Text(
                          "${widget.origin}  ",
                          style: TextStyle(fontSize: 15, color: Colors.green[900]),
                        ),
                        Icon(Icons.arrow_circle_right_outlined),
                        Text(
                          "  ${widget.destination}",
                          style: TextStyle(fontSize: 15, color: Colors.green[900]),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "06:25 ",
                              style: TextStyle(fontSize: 20, color: Colors.green[900]),
                            ),
                            Icon(Icons.arrow_circle_right_outlined  ,color: Colors.green[900]),
                            Text(
                              " 07:55",
                              style: TextStyle(fontSize: 20, color: Colors.green[900]),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _seat,
                          decoration: InputDecoration(
                            icon: Icon(Icons.event_seat, color: Colors.green[900]),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            labelText: "เลือกที่นั่ง",
                            labelStyle: TextStyle(fontSize: 14),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                          ),
                          onTap: () {
                            _showDropdown(context);
                          },
                          readOnly: true,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('รายละเอียดการเดินทาง'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('คุณ ${widget.name}'),
                                      Text('เดินทางจาก ${widget.origin} ไป ${widget.destination}'),
                                      SizedBox(height: 20),
                                      Container(
                                        width: 100, // กำหนดความกว้างของรูป
                                        height: 100, // กำหนดความสูงของรูป
                                        child: Image.asset('image/qrcode.png'), // เปลี่ยนเส้นทางไปยังรูปภาพตามที่คุณนำเข้า
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return MyApp();
                                            }));
                                      },
                                      child: Text('เสร็จสิ้น'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('ชำระเงิน'),

                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showDropdown(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ที่นั่ง'),
          content: DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
                _seat.text = newValue; // Update text field value
              });
              Navigator.of(context).pop();
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
