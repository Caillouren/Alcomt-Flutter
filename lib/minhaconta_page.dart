import 'package:flutter/material.dart';

class MinhaContaPage extends StatefulWidget {
  @override
  _MinhaContaPageState createState() => _MinhaContaPageState();
}

class _MinhaContaPageState extends State<MinhaContaPage> {
  String nome = 'Igor Yuri';
  String email = 'igor.yuri@gmail.com';
  String telefone = '(81) 981992341';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Minha Conta'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
              'Nome',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              nome,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'E-mail',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              email,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Telefone',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              telefone,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Ação do botão "Ver áreas de interesse"
              },
              child: Text('Ver áreas de interesse'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Ação do botão "Alterar senha"
              },
              child: Text('Alterar senha'),
            ),
          ],
        ),
      ),
    );
  }
}
