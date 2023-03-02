import 'package:flutter/material.dart';

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
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logo_alcomt.png'),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 15,
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
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
