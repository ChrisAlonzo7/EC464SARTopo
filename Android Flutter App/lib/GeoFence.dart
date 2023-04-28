// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
  bool isInside = false;
  int i = 0;
  int j = polygon.length - 1;

  while (i < polygon.length) {
    if (((polygon[i].longitude > point.longitude) !=
            (polygon[j].longitude > point.longitude)) &&
        (point.latitude <
            (polygon[j].latitude - polygon[i].latitude) *
                    (point.longitude - polygon[i].longitude) /
                    (polygon[j].longitude - polygon[i].longitude) +
                polygon[i].latitude)) {
      isInside = !isInside;
    }
    j = i;
    i++;
  }

  return isInside;
}

List<LatLng> parseGeoJsonToPolygon(String geoJsonString) {
  final geoJson = json.decode(geoJsonString);
  print('geoJson: $geoJson');
  final List<dynamic> coordinates =
      geoJson['features'][0]['geometry']['coordinates'][0];
  print('coordinates: $coordinates');
  final polygon =
      coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
  print('polygon: $polygon');
  return polygon;
}

Future<List<Map<String, double>>> readCoordinatesFromFile(
    String filePath) async {
  final contents = await rootBundle.loadString(filePath);
  final lines = contents.split('\n');
  final coordinates = <Map<String, double>>[];

  for (int i = 1; i < lines.length; i++) {
    final parts = lines[i].split(',');

    if (parts.length >= 2) {
      final lat = double.tryParse(parts[0]);
      final lon = double.tryParse(parts[1]);

      if (lat != null && lon != null) {
        coordinates.add({'lat': lat, 'lon': lon});
      }
    }
  }

  return coordinates;
}

Future<void> checkCoordinates(
    List<Map<String, double>> coordinates, List<LatLng> polygon) async {
  for (Map<String, double> coord in coordinates) {
    LatLng point = LatLng(coord['lat']!, coord['lon']!);
    bool isInside = isPointInPolygon(point, polygon);
    print(
        'Coordinate: ${coord['lat']}, ${coord['lon']} is inside polygon: $isInside');
    await Future.delayed(const Duration(seconds: 1));
  }
}
