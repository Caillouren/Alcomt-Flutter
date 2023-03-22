import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class adicNotifPage extends StatefulWidget {
  const adicNotifPage({Key? key}) : super(key: key);

  @override
  _adicNotifPageState createState() => _adicNotifPageState();
}

class _adicNotifPageState extends State<adicNotifPage> {
  double lat = 0.0;
  double long = 0.0;
  String erro = '';
  Set<Marker> markers = Set<Marker>();
  GoogleMapController? _mapsController;

  get mapsController => _mapsController;

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
