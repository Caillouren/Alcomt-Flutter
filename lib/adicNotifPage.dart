import 'package:flutter/material.dart';

class adicNotifPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text("Tipo", style: TextStyle(color: Colors.white)),
            SizedBox(height: 8.0),
            _buildDropdownButton(["Chuva", "Batida", "Interditada"]),
            SizedBox(height: 16.0),
            Text("Bairro", style: TextStyle(color: Colors.white)),
            SizedBox(height: 8.0),
            _buildDropdownButton(["Boa Viagem", "Boa Vista", "Madalena"]),
            SizedBox(height: 16.0),
            Text("Descrição", style: TextStyle(color: Colors.white)),
            SizedBox(height: 8.0),
            Expanded(
              child: TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {},
              child: Text("Enviar"),
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
