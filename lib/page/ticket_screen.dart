import 'package:chapter4_cloud_firestore/page/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'detail_ticket.dart';

List<String> list = <String>[
  'สถานีขนส่งผู้โดยสาร จ.พะเยา',
  'ทสถานีขนส่งผู้โดยสาร จ.พิษณุโลก',
  'สถานีขนส่งผู้โดยสาร จ.ลำปาง',
  'สถานีขนส่งผู้โดยสาร จ.เชียงราย',
  'สถานีขนส่งผู้โดยสาร จ.เชียงใหม่',
  'สถานีขนส่งผู้โดยสาร จ.แพร่',
];

List<String> list1 = <String>[
  'สถานีขนส่งผู้โดยสาร จ.พะเยา',
  'ทสถานีขนส่งผู้โดยสาร จ.พิษณุโลก',
  'สถานีขนส่งผู้โดยสาร จ.ลำปาง',
  'สถานีขนส่งผู้โดยสาร จ.เชียงราย',
  'สถานีขนส่งผู้โดยสาร จ.เชียงใหม่',
  'สถานีขนส่งผู้โดยสาร จ.แพร่',
];



class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreen();
}

class _TicketScreen extends State<TicketScreen> {
  TextEditingController _name = TextEditingController(); //ชื่อ
  TextEditingController _id = TextEditingController(); //รหัสบัตร ปชช
  TextEditingController _origin = TextEditingController(); //เมืองต้นทาง
  TextEditingController _destination = TextEditingController(); //เมืองปรายทาง
  TextEditingController _numticket = TextEditingController(); //จำนวนตั๋ว
  var selectedDate; //วันที่เดินทางไป

  String dropdownValue = list.first;
  String dropdownValue1 = list1.first;
  //ส่วนเป็นการสร้าง Object studentCollection เป็นตัวแทนของ student
  CollectionReference busCollection =
      FirebaseFirestore.instance.collection("bus");

  bool _isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูลการเดินทาง",
            style: TextStyle(
                fontSize: 20, fontFamily: 'Mitr', color: Colors.green[900])),
        leading: Icon(
          Icons.bus_alert,
          color: Colors.green[900],
        ),
        actions: [
          CircleAvatar(
            // substring หั่นตัวอักษร เพื่อโชวอักษรตัวแรก โดยตำแหน่ง เริ่มที่ 0 จบที่ 1
            child: Text(FirebaseAuth.instance.currentUser!.email
                .toString()
                .substring(0, 1)),
          ),
          IconButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return SignInScreen();
                  }), (route) => false);
                });
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: InputDecoration(
                icon: Icon(Icons.people, color: Colors.green[900]),
                labelText: "ชื่อ-นามสกุล",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _id,
              decoration: InputDecoration(
                icon: Icon(Icons.person_remove_alt_1_rounded, color: Colors.green[900]),
                labelText: "รหัสบัตรประชาชน",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _origin,
              decoration: InputDecoration(
                icon: Icon(Icons.location_on_sharp, color: Colors.green[900]),
                suffixIcon: Icon(Icons.arrow_drop_down),
                labelText: "ต้นทาง",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              ),
              onTap: () {
                _showDropdown(context);
              },
              readOnly: true,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _destination,
              decoration: InputDecoration(
                icon: Icon(Icons.location_on_sharp, color: Colors.green[900]),
                suffixIcon: Icon(Icons.arrow_drop_down),
                labelText: "ปรายทาง",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              ),
              onTap: () {
                _showDropdown1(context);
              },
              readOnly: true,
            ),
            SizedBox(
              height: 10,
            ),
            DateTimeFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.date_range, color: Colors.green[900]),
                labelText: 'วันเดินทางไป',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              firstDate: DateTime.now().add(const Duration(days: 10)),
              lastDate: DateTime.now().add(const Duration(days: 40)),
              mode: DateTimeFieldPickerMode.date,
              onChanged: (DateTime? value) {
                selectedDate = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _numticket,
              decoration: InputDecoration(
                icon: Icon(Icons.airplane_ticket_rounded, color: Colors.green[900]),
                labelText: "จำนวนตั๋ว",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: (_isChecked)
                        ? () async {
                            var name = _name.text.toString();
                            var id = _origin.text.toString();
                            var origin = _origin.text.toString();
                            var destination = _destination.text.toString();
                            var numticket = _numticket.text.toString();

                            if (name.isEmpty ||
                                id.isEmpty ||
                                origin.isEmpty ||
                                destination.isEmpty ||
                                selectedDate == "" ||
                                numticket.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("กรุณากรอกข้อมูลให้ครบ"),
                                backgroundColor: Colors.orange,
                              ));
                            } else {
                              setState(() {
                                _isChecked = false;
                              });

                              await busCollection.add({
                                "name":name,
                                "id":id,
                                "origin": origin,
                                "destination": destination,
                                "selecteddate": selectedDate,
                                "numticket": numticket
                              }).then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("บันทึกข้อมูลสำเร็จ"),
                                  backgroundColor: Colors.green,
                                )); // callbackFunction

                                // _name.clear();
                                // _id.clear();
                                // _origin.clear();
                                // _destination.clear(); // clear ใข้สำหรับ Controller
                                // selectedDate = " "; // กำหนดให้เป็นค่าว่าง
                                // _numticket.clear();

                                setState(() {
                                  _isChecked = true;
                                });
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return DetailTiclet(name, id, origin, destination,
                                      selectedDate.toString(), numticket);

                                }));
                              });
                            }
                          }
                        : null,
                    child: (_isChecked)
                        ? Text(
                            "CONFIRM",
                            style: TextStyle(color: Colors.green[900]),
                          )
                        : SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.5,
                            ),
                          ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.green),
                    )))
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
          title: Text('ต้นทาง'),
          content: DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
                _origin.text = newValue; // Update text field value
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

  void _showDropdown1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ปรายทาง'),
          content: DropdownButton<String>(
            value: dropdownValue1,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue1 = newValue!;
                _destination.text = newValue; // Update text field value
              });
              Navigator.of(context).pop();
            },
            items: list1.map<DropdownMenuItem<String>>((String value) {
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


