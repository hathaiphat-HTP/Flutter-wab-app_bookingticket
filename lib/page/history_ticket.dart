import 'package:chapter4_cloud_firestore/page/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _History();
}

class _History extends State<History> {
  CollectionReference busCollection =
  FirebaseFirestore.instance.collection("bus");

  bool _checkState = true;

  TextEditingController _name = TextEditingController(); //ชื่อ
  TextEditingController _id = TextEditingController(); //รหัสบัตร ปชช
  TextEditingController _origin = TextEditingController(); //เมืองต้นทาง
  TextEditingController _destination = TextEditingController(); //เมืองปรายทาง
  TextEditingController _numticket = TextEditingController();
  TextEditingController _selecteddate = TextEditingController();
  var selectedDate;

  String dropdownValue = list.first;
  String dropdownValue1 = list1.first;

  //จำนวนตั๋ว

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("หน้าประวัติการจอง"),
        actions: [
          CircleAvatar(
            // substring หั่นตัวอักษร เพื่อโชวอักษรตัวแรก โดยตำแหน่ง เริ่มที่ 0 จบที่ 1
            child: Text(FirebaseAuth.instance.currentUser!.email.toString().substring(0,1)),
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
              icon: Icon(Icons.logout)
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: busCollection.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error : ${snapshot.hasError.toString()}"),
              );
            } else if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text("ไม่มีข้อมูล..."),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot bus = snapshot.data.docs[index];
                return Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    elevation: 6,
                    shadowColor: Colors.grey,
                    child: ListTile(
                      title: Text(bus['name'].toString()),
                      subtitle: Text("เดินทางจาก " + bus['origin'].toString() + " ไป " + bus['origin'].toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    _name.text = bus['name'];
                                    _origin.text = bus['origin'];
                                    _destination.text = bus['destination'];
                                    _numticket.text = bus['numticket'];
                                    _selecteddate.text = bus['selecteddate'];
                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          void Function(void Function())
                                          setState) {
                                        return AlertDialog(
                                          actions: [
                                            OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('ยกเลิก',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15)),
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor:
                                                  Colors.red.shade700),
                                            ),
                                            OutlinedButton(
                                              onPressed: () async {
                                                setState(() {
                                                  _checkState = false;
                                                });
                                                var name =
                                                _name.text.toString();
                                                var origin =
                                                _origin.text.toString();
                                                var destination =
                                                _destination.text.toString();
                                                var numticket =
                                                _numticket.text.toString();
                                                var selecteddate =
                                                _selecteddate.text.toString();

                                                await busCollection
                                                    .doc(bus.id)
                                                    .update({
                                                  "name": name,
                                                  "origin": origin,
                                                  "destination": destination,
                                                  "numticket": numticket,
                                                  "selecteddate" :selecteddate
                                                }).then((value) {
                                                  setState(() {
                                                    _checkState = true;
                                                  });
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "แก้ไขข้อมูลสำเร็จ"),
                                                    backgroundColor:
                                                    Colors.green,
                                                  )); // callbackFunction
                                                });
                                              },
                                              child: (_checkState)?Text(
                                                'แก้ไข',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ):SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 1.5,
                                                ),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .yellowAccent.shade700),
                                            ),
                                          ],
                                          //หน้าต่างสีเทา
                                          title: Text("แก้ไขข้อมูล"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min, //ขนาดเท่ากับฟอร์ม
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
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.amberAccent,
                              )),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          void Function(void Function())
                                          setState) {
                                        return AlertDialog(
                                          title: Text("คุณต้องการลบหรือไม่ ?"),
                                          content: Text(" "),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "ยกเลิก",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                            TextButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    _checkState = false;
                                                  });
                                                  await busCollection
                                                      .doc(bus.id)
                                                      .delete()
                                                      .then((value) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "ลบข้อมูลสำเร็จ"),
                                                      backgroundColor:
                                                      Colors.green,
                                                    ));
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: (_checkState)
                                                    ? Text(
                                                  "ยืนยัน",
                                                  style: TextStyle(
                                                      color:
                                                      Colors.green),
                                                )
                                                    : SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child:
                                                  CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 1.5,
                                                  ),
                                                )),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.pink,
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
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