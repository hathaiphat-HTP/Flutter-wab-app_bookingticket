import 'package:chapter4_cloud_firestore/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  final auth = FirebaseAuth.instance;

  bool _isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "เข้าสู้ระบบ",
              style: TextStyle(fontSize:20,fontFamily:'Mitr',color: Colors.green[900]),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _email,
              decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: "email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40))),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              controller: _password,
              decoration: InputDecoration(
                  icon: Icon(Icons.key),
                  labelText: "password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40))),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var email = _email.text.toString();
                  var pass = _password.text.toString();
                  setState(() {
                    _isChecked = false;
                  });
                  try {
                    await auth
                        .signInWithEmailAndPassword(
                            email: email, password: pass)
                        .then((value) {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MyApp();
                      }), (route) => false);
                    });
                  } on FirebaseAuthException catch (e) {
                    print(e.message);
                    setState(() {
                      _isChecked = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[900], // เปลี่ยนสีพื้นหลังตามที่ต้องการ
                ),
                child: (_isChecked) ? Text("Login", style: TextStyle(color: Colors.white),)
                    : SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1.5,
                        ),
                      ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      registerEmail();
                    },
                    child: Text("Register",style: TextStyle(color: Colors.green[900]),)),
                TextButton(onPressed: () {}, child: Text("Forget password",style: TextStyle(color: Colors.redAccent))),
              ],
            )
          ],
        ),
      ),
    );
  }

  registerEmail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Register Email"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: "email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: true,
                    controller: _password,
                    decoration: InputDecoration(
                      icon: Icon(Icons.key),
                      labelText: "password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        var email = _email.text.toString();
                        var pass = _password.text.toString();
                        // ใช้สำหรับตรวจสอบ Error การสมัครเข้าสู่ระบบ
                        try {
                          setState(() {
                            _isChecked = false;
                          });
                          await auth
                              .createUserWithEmailAndPassword(
                              email: email, password: pass)
                              .then((value) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("สร้างบัญชีสำเร็จ"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          });
                        } on FirebaseAuthException catch (e) {
                          //แสดง Error แบบละเอียดแบบยาว
                          print(e.message);
                        } finally {
                          setState(() {
                            _isChecked = true;
                          });
                        }
                      },
                      child: (_isChecked)
                          ? Text("Register")
                          : SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
