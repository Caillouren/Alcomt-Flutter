import 'package:alcomt_puro/minhaconta_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alcomt_puro/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alcomt_puro/adicNotifPage.dart';

class NotificacaoEspecificaPage extends StatelessWidget {
  final DocumentSnapshot notificacao;

  NotificacaoEspecificaPage({required this.notificacao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificação Específica'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notificacao['bairro'],
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              DateTime.fromMillisecondsSinceEpoch(
                      notificacao['data'].millisecondsSinceEpoch)
                  .toString(),
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 18.0),
            FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          adicNotifPage(auth: FirebaseAuth.instance)),
                );
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
