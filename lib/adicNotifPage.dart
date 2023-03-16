import 'package:flutter/material.dart';

class adicNotifPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Adicionar Notificação",
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,          
          children: [
            Image.asset(
            'assets/logo_alcomt.png',
            width: 250,
            height: 250,
          ),
            Text("Tipo de alerta", style: TextStyle(color: Colors.white)),
            SizedBox(height: 8.0),
            _buildDropdownButton(["Chuva", "Batida", "Interditada"]),
            SizedBox(height: 16.0),
            Text("Bairro", style: TextStyle(color: Colors.white)),
            SizedBox(height: 8.0),
            _buildDropdownButton(["Boa Viagem", "Boa Vista", "Madalena"]),
            SizedBox(height: 16.0),
            Text("Descrição",style: TextStyle(color: Colors.white)),
            SizedBox(height: 8.0),
            Container(
              height: 200,
              child: TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Descreva aqui mais detalhes sobre o alerta...",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 0.0),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Enviar",
                style: TextStyle(
                  color: Colors.black, // define a cor do texto como preto
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton(List<String> options) {
    String selectedOption = options.first;

    return DropdownButton<String>(
      value: selectedOption,
      onChanged: (String? value) {
        if (value != null) {
          selectedOption = value;
        }
      },
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }
}
