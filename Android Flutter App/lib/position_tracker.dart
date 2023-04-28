// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:http/http.dart' as http;

Future<void> sendPositionUpdate(
    String callSign, String userId, double lat, double lon) async {
  final url =
      'https://caltopo.com/api/v1/position/report/$callSign?id=$userId&lat=$lat&lng=$lon';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print('Position update sent successfully');
  } else {
    print('Failed to send position update');
  }
}
