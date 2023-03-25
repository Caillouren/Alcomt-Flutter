import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:alcomt_puro/mapPage.dart';

class adicNotifPage extends StatefulWidget {
  final FirebaseAuth auth;
  const adicNotifPage({Key? key, required this.auth}) : super(key: key);

  @override
  _adicNotifPageState createState() => _adicNotifPageState();
}

class _adicNotifPageState extends State<adicNotifPage> {
  List<String> _bairros = []; // Lista de bairros
  List<String> _tiposAlerta = ["Chuva", "Batida", "Interditada"];
  String selectedBairro = '';
  String selectedTipoAlerta = '';
  TextEditingController _descricaoController = TextEditingController();
  double lat = 0.0; //mapa
  double long = 0.0; //mapa
  String erro = ''; //mapa
  String _path = '';
  String imageName = '';
  FirebaseStorage storage = FirebaseStorage.instance;
  File? _image;
  final CollectionReference<Map<String, dynamic>> notificacoesRef =
      FirebaseFirestore.instance.collection('notificacoes');

  @override
  void initState() {
    super.initState();
    loadBairros(); // Carrega os bairros a partir do arquivo CSV
  }

// Upload de imagens
  String generateImageName() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        '_${_image?.hashCode}.png';
  }

  Future<void> uploadFile() async {
    try {
      final Reference ref = storage.ref().child(
          'images/${DateTime.now().millisecondsSinceEpoch.toString()}.png');
      final SettableMetadata metadata = SettableMetadata(
          contentType: 'image/png',
          customMetadata: {'order': 'file upload test'});
      final UploadTask uploadTask = ref.putFile(_image!, metadata);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String urlDownload = await snapshot.ref.getDownloadURL();
      print('URL de Download: $urlDownload');

      final CollectionReference<Map<String, dynamic>> imagesRef =
          FirebaseFirestore.instance.collection('images');
      await imagesRef
          .doc(DateTime.now().toIso8601String())
          .set({'imageUrl': urlDownload});
    } catch (e) {
      print('Erro ao fazer upload do arquivo: $e');
    }
  }

  Future<Directory> getApplicationDocumentsDirectory() async {
    return await path_provider.getApplicationDocumentsDirectory();
  }

  void _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: source);

    if (pickedFile == null) {
      return;
    }

    final appDir = await path_provider.getApplicationDocumentsDirectory();
    imageName = generateImageName();
    final imagePath = path.join(appDir.path, imageName);

    try {
      await File(pickedFile.path).copy(imagePath);
      setState(() {
        _image = File(imagePath);
      });
    } catch (e) {
      print('Erro ao salvar a imagem: $e');
    }
  }

  //importa os bairros do Recife
  Future<void> loadBairros() async {
    final String bairrosString =
        await rootBundle.loadString('assets/bairrosRecife.csv');
    _bairros.addAll(convertCsvToListOfString(bairrosString));
    setState(() {});
  }

  // Converte uma string CSV em uma lista de strings
  List<String> convertCsvToListOfString(String csvString) {
    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(csvString);
    return rowsAsListOfValues.map((e) => e.first.toString()).toList();
  }

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
            _buildDropdownButtonAlerta(
                _tiposAlerta), //seleciona o tipo de alerta
            SizedBox(height: 16.0),
            Text("Bairro", style: TextStyle(color: Colors.white)),
            SizedBox(height: 8.0),
            _buildDropdownButton(_bairros), //seleciona o bairro
            SizedBox(height: 16.0),
            Text("Descrição", style: TextStyle(color: Colors.white)),
            SizedBox(height: 8.0),
            Container(
              height: 200,
              child: TextFormField(
                //campo de descrição
                controller: _descricaoController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Descreva aqui mais detalhes sobre o alerta...",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            //Carregar imagem
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Container(
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Câmera'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Galeria'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                'Adicionar imagem',
                style: TextStyle(
                  color: Colors.black, // define a cor do texto como preto
                ),
              ),
            ),
            SizedBox(height: 16.0),
            //Navegar para a tela do mapa
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => mapPage()),
                );
              },
              child: Text(
                'Marcar Posição',
                style: TextStyle(
                  color: Colors.black, // define a cor do texto como preto
                ),
              ),
            ),
            //enviar dados
            ElevatedButton(
              onPressed: () async {
                if (_image != null) {
                  final metadata = SettableMetadata(
                    contentType: 'image/jpeg',
                    customMetadata: {'picked-file-path': _image!.path},
                  );
                  final snapshot = await FirebaseStorage.instance
                      .ref()
                      .child('images')
                      .child(imageName)
                      .putFile(_image!, metadata);
                  final imageUrl = await snapshot.ref.getDownloadURL();
                  notificacoesRef.add({
                    'tipo': selectedTipoAlerta,
                    'bairro': selectedBairro,
                    'descricao': _descricaoController.text,
                    'latitude': lat,
                    'longitude': long,
                    'imagem': imageUrl,
                    'data': DateTime.now(),
                  });
                } else {
                  notificacoesRef.add({
                    'tipo': selectedTipoAlerta,
                    'bairro': selectedBairro,
                    'descricao': _descricaoController.text,
                    'latitude': lat,
                    'longitude': long,
                    'data': DateTime.now(),
                  });
                }
              },
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
    String selectedOption = options.isNotEmpty ? options.first : '';

    return DropdownButton<String>(
      value: selectedOption,
      onChanged: (String? value) {
        if (value != null) {
          selectedOption = value;
          selectedBairro = value;
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

  Widget _buildDropdownButtonAlerta(List<String> options) {
    String selectedOption = options.isNotEmpty ? options.first : '';

    return DropdownButton<String>(
      value: selectedOption,
      onChanged: (String? value) {
        if (value != null) {
          selectedOption = value;
          selectedTipoAlerta = value;
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
