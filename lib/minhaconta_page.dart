import 'package:flutter/material.dart';
import 'package:alcomt_puro/editar_areas_page.dart';
import 'package:alcomt_puro/MenuPage.dart';

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
        title: Text(
          'Minha Conta',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black, // define o background preto do appBar
        leading: IconButton(
          //icone <-
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // define a cor do ícone como branca
          ),
          onPressed: () {
            Navigator.push(
              //Navega para a página
              context,
              MaterialPageRoute(builder: (context) => MenuPage()),
            );
          },
        ),
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
                // Ação do botão "Editar áreas de interesse"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditBairroPage()),
                ); // código para salvar o cadastro
              },
              child: Text(
                'Editar áreas de interesse',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Ação do botão "Alterar senha"
              },
              child: Text(
                'Alterar senha',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
