import 'package:chapter4_cloud_firestore/page/ticket_screen.dart';
import 'package:chapter4_cloud_firestore/page/history_ticket.dart';
import 'package:chapter4_cloud_firestore/page/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAKT5f30ZlZMIdUErn_uaxGaZVV7QNZ1sI",
          appId: "1:994850625306:web:6fb130818d30618530fea3",
          messagingSenderId: "994850625306",
          projectId: "flutter-firebase-cloud-2fbac"));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignInScreen(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            tabs: [
              Tab(
                child: Text("ticket",style: TextStyle(color: Colors.green[900]),),
              ),
              Tab(
                child: Text("Ticket point"),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              TicketScreen(),
              History(),
            ],
          ),
        ),
    );
  }

}


