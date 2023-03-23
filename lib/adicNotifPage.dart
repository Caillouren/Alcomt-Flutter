import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class adicNotifPage extends StatefulWidget {
  final FirebaseAuth auth;
  const adicNotifPage({Key? key, required this.auth}) : super(key: key);

  @override
  _adicNotifPageState createState() => _adicNotifPageState();
}

class _adicNotifPageState extends State<adicNotifPage> {
  double lat = 0.0;
  double long = 0.0;
  String erro = '';
  String _path = '';
  Set<Marker> markers = Set<Marker>();
  GoogleMapController? _mapsController;
  FirebaseStorage storage = FirebaseStorage.instance;
  File? _image;
  final CollectionReference<Map<String, dynamic>> notificacoesRef =
      FirebaseFirestore.instance.collection('images');

  get mapsController => _mapsController;

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

  Future<void> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    } else {
      final file = File(pickedFile.path);
      final fileName = basename(file.path); //nome file

      // Define diretório
      final directory = await getApplicationDocumentsDirectory();
      final destinationPath = join(directory.path, fileName);

      // copia p/ diretório
      await file.copy(destinationPath);
    }

    try {
      final appDir = await path_provider.getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImagePath = '${appDir.path}/$fileName';
      await File(pickedFile.path).copy(savedImagePath);
      setState(() {
        _image = File(savedImagePath);
      });
    } catch (e) {
      print('Erro ao salvar a imagem: $e');
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    _mapsController = controller;
    await getPosicao();
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId('Minha posição'),
          position: LatLng(lat, long),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
    _mapsController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(lat, long),
        18,
      ),
    );
  }

  getPosicao() async {
    bool permissaoGPS = await Permission.location.isGranted;
    if (!permissaoGPS) {
      var status = await Permission.location.request();
      if (status != PermissionStatus.granted) {
        return Future.error('Permissão de localização negada');
      }
    }
    try {
      Position posicao = await _posicaoAtual();
      setState(() {
        lat = posicao.latitude;
        long = posicao.longitude;
        markers.add(
          Marker(
            markerId: MarkerId('Minha posição'),
            position: LatLng(lat, long),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      });
      _mapsController?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    } catch (e) {
      erro = e.toString();
    }
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;

    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error('Por favor, habilite a localização no smartphone');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Você precisa autorizar o acesso à localização');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    lat = position.latitude;
    long = position.longitude;
    _mapsController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(lat, long),
        18,
      ),
    );
    return position;
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
            _buildDropdownButton(["Chuva", "Batida", "Interditada"]),
            SizedBox(height: 16.0),
            Text("Bairro", style: TextStyle(color: Colors.white)),
            SizedBox(height: 8.0),
            _buildDropdownButton(["Boa Viagem", "Boa Vista", "Madalena"]),
            SizedBox(height: 16.0),
            Text("Descrição", style: TextStyle(color: Colors.white)),
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
              child: Text('Adicionar imagem'),
            ),
            SizedBox(height: 16.0),
            if (lat != 0.0 && long != 0.0)
              SizedBox(
                height: 500,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, long),
                    zoom: 18,
                  ),
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  onMapCreated: onMapCreated,
                  markers: markers,
                ),
              ),
            SizedBox(height: 16.0),
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
                      .child('imagem.jpg')
                      .putFile(_image!, metadata);
                  final imageUrl = await snapshot.ref.getDownloadURL();
                  notificacoesRef.add({
                    //'tipo': _tipoAlerta,
                    //'bairro': _bairro,
                    //'descricao': _descricao,
                    'latitude': lat,
                    'longitude': long,
                    'imagem': imageUrl,
                    'data': DateTime.now(),
                  });
                } else {
                  notificacoesRef.add({
                    //'tipo': _tipoAlerta,
                    //'bairro': _bairro,
                    //'descricao': _descricao,
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
