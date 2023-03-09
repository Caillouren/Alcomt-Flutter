import 'package:alcomt_puro/minhaconta_page.dart';
import 'package:flutter/material.dart';
import 'package:alcomt_puro/LoginPage.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

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
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              //Navega para a página
              context,
              MaterialPageRoute(builder: (context) => BemVindoPage()),
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MinhaContaPage()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/person-icon.png',
                      height: 20,
                    ),
                    SizedBox(width: 1),
                  ],
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 20),
                  ),
                  textStyle: MaterialStateProperty.all(
                    TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
          Image.asset(
            'assets/logo_alcomt.png',
            width: 200,
            height: 200,
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.black,
                  child: ListTile(
                    title: Text(
                      'Opção ${index + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => adicNotifPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
