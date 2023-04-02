import 'package:alcomt_puro/minhaconta_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alcomt_puro/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alcomt_puro/adicNotifPage.dart';
import 'package:alcomt_puro/NotificacaoEspecificaPage.dart';

class MenuPage extends StatefulWidget {
  final FirebaseAuth auth;
  const MenuPage({Key? key, required this.auth}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
  }

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
            await widget.auth.signOut(); // Desautentica o usuário
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(auth: widget.auth)),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                  minHeight: 40), // altura mínima definida para o container
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Spacer(),
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/person-icon.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      //botão minha conta
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MinhaContaPage(auth: widget.auth)),
                            );
                          },
                          child: SizedBox(
                            width: 80,
                            height: 40,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Image.asset(
              'assets/logo_alcomt.png',
              width: 200,
              height: 200,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notificacoes')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final notificacao = snapshot.data!.docs[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificacaoEspecificaPage(
                                notificacao: notificacao),
                          ),
                        );
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
          ],
        ),
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
