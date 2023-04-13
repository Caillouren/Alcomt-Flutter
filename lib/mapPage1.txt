import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:alcomt_puro/adicNotifPage.dart';

//pagina mapa
class mapPage extends StatefulWidget {
  @override
  _mapPageState createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {
  // Declaração das variáveis que serão utilizadas
  GoogleMapController? _controller;
  LatLng? _currentLocation;
  LatLng? _markedLocation;
  String? _address;

  // Configuração inicial do mapa
  static final CameraPosition initialPosition = CameraPosition(
    target: LatLng(-23.5505, -46.6333),
    zoom: 14.0,
  );

  // Função que marca um ponto no mapa
  void _onMapTapped(LatLng location) async {
    setState(() {
      _markedLocation = location;
    });
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _markedLocation!.latitude, _markedLocation!.longitude);
    Placemark placemark = placemarks[0];
    setState(() {
      _address =
          "${placemark.thoroughfare}, ${placemark.subThoroughfare} - ${placemark.subLocality}, ${placemark.locality} - ${placemark.administrativeArea}";
    });
  }

  // Função que salva a localização marcada e envia para a próxima página
  void _saveLocation() {
    Navigator.of(context).pushNamed('/adicNotifPage', arguments: {
      'location': _markedLocation,
      'address': _address,
    });
  }

  // Verifica se o serviço de localização está habilitado
  Future<bool> isLocationServiceEnabled() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    return true;
  }

  Future<bool> checkPermission() async {
    var permissionStatus = await Permission.location.status;
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await Permission.location.request();
      if (permissionStatus != PermissionStatus.granted &&
          permissionStatus != PermissionStatus.grantedLimited) {
        return false;
      }
    }
    return true;
  }

  // Obtém a localização atual do usuário
  Future<void> _getCurrentLocation() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      if (await Permission.location.request().isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
      } else {
        // a permissão foi negada
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Permissão de localização"),
              content: Text(
                  "Para usar o aplicativo, você precisa habilitar a permissão de localização."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Habilitar"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (await Permission.location.request().isGranted) {
                      // a permissão foi concedida
                      // chama a função novamente para obter a localização atual
                      _getCurrentLocation(context);
                    }
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // o serviço de localização não está habilitado
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Serviço de localização desativado'),
          content: Text(
              'O serviço de localização está desativado. Por favor, habilite o serviço de localização nas configurações do dispositivo.'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  Future<Position?> getCurrentPosition(
      {required LocationAccuracy desiredAccuracy, Duration? timeout}) async {
    if (!await isLocationServiceEnabled()) {
      throw LocationServiceDisabledException();
    }

    var status = await checkPermission();
    if (status == PermissionStatus.denied) {
      throw PermissionDeniedException();
    }

    if (status == PermissionStatus.granted ||
        status == PermissionStatus.grantedLimited) {
      try {
        return await GeolocatorPlatform.instance.getCurrentPosition(
            desiredAccuracy: desiredAccuracy, timeout: timeout);
      } on PlatformException catch (e) {
        throw _convertPlatformException(e);
      }
    }

    // Request permission
    status = await requestPermission();
    if (status == PermissionStatus.granted) {
      try {
        return await GeolocatorPlatform.instance.getCurrentPosition(
            desiredAccuracy: desiredAccuracy, timeout: timeout);
      } on PlatformException catch (e) {
        throw _convertPlatformException(e);
      }
    }

    throw PermissionDeniedException();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        onTap: _onMapTapped,
        initialCameraPosition: _currentLocation != null
            ? CameraPosition(
                target: _currentLocation!,
                zoom: 14.0,
              )
            : initialPosition,
        markers: _markedLocation != null
            ? {
                Marker(
                  markerId: MarkerId("markedLocation"),
                  position: _markedLocation!,
                ),
              }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _markedLocation != null ? _saveLocation : null,
        child: Icon(Icons.save),
      ),
    );
  }
}
