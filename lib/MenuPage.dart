import 'package:alcomt_puro/minhaconta_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alcomt_puro/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alcomt_puro/adicNotifPage.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key, required this.auth}) : super(key: key);
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Menu',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () async {
            await auth.signOut(); // Desautentica o usuário
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage(auth: auth)),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('notificacoes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final notificacao = snapshot.data!.docs[index];

              return GestureDetector(
                onTap: () {
                  //Navigator.push(
                  //context,
                  //MaterialPageRoute(
                  //builder: (context) => NotifiEspecificaPage(notificacao: notificacao),
                  //    ),
                  //);
                },
                child: Card(
                  child: ListTile(
                    title: Text(
                      notificacao['bairro'],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      DateTime.fromMillisecondsSinceEpoch(
                              notificacao['data'].millisecondsSinceEpoch)
                          .toString(),
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
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
      ),
    );
  }
}
