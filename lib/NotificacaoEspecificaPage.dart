import 'package:alcomt_puro/minhaconta_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alcomt_puro/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alcomt_puro/adicNotifPage.dart';
import 'package:intl/intl.dart';

class NotificacaoEspecificaPage extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> notificacao;
  const NotificacaoEspecificaPage({Key? key, required this.notificacao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = notificacao.data() as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificação Específica'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['bairro'],
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              DateFormat('dd/MM/yyyy').format(data['data'].toDate()),
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              data['descricao'],
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 16.0),
            if (data.containsKey('imagem'))
              Image.network(
                data['imagem'],
                width: 200,
                height: 200,
              ),
            SizedBox(height: 16.0),
            Text(
              'Tipo: ${data['tipo']}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
