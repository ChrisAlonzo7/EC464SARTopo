// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:xml/xml.dart' as xml;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

Future<void> convertToGpx(String filePath, String gpxFilePath) async {
// Read the GPS data file.
  final File file = File(filePath);
  final String fileData = await file.readAsString();

// Split the data into lines and parse each line to extract the necessary information.
  final List<String> lines = fileData.split('\n');
  final List<Map<String, dynamic>> gpsData = [];

  for (int i = 1; i < lines.length; i++) {
    final line = lines[i];
    if (line.isEmpty) {
      break; // stop reading data once an empty line is encountered
    }

    try {
      final List<String> parts = line.split(',');
      final lat = double.tryParse(parts[0]);
      final lon = double.tryParse(parts[1]);
      final time = DateFormat("yyyy-M-d H:m:s").parse(parts[2]);

      gpsData.add({
        'lat': lat,
        'lon': lon,
        'time': time,
      });
    } catch (e) {
      print('Malformed line $i: $line');
    }
  }

  // Create a new GPX document with the appropriate XML tags.
  final xml.XmlBuilder builder = xml.XmlBuilder();
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  builder.processing('xml', 'version="1.0" encoding="utf-8" standalone="yes"');
  builder.element('gpx', nest: () {
    builder.attribute('xmlns', 'http://www.topografix.com/GPX/1/1');
    builder.attribute(
        'xmlns:gpxx', 'http://www.garmin.com/xmlschemas/GpxExtensions/v3');
    builder.attribute('creator', 'YCSRAPP');
    builder.attribute('version', '1.1');
    builder.element('trk', nest: () {
      builder.element('name', nest: 'GPS Data');
      builder.element('trkseg', nest: () {
        for (Map<String, dynamic> data in gpsData) {
          builder.element('trkpt', nest: () {
            builder.attribute('lat', data['lat'].toString());
            builder.attribute('lon', data['lon'].toString());
            builder.element('time', nest: dateFormat.format(data['time']));
          });
        }
      });
    });
  });
  final xml.XmlDocument gpxDoc = builder.buildDocument();

  // Save the GPX document to the specified file with a .gpx extension.
  final File gpxFile = File(gpxFilePath);

  Directory? externalDir = await getExternalStorageDirectory();
  print(externalDir?.path);

  await gpxFile.writeAsString(gpxDoc.toXmlString(pretty: true));
}
