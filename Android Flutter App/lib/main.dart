// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'position_tracker.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'Convert_to_GPX.dart';
//import 'GeoFence.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
//import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp(key: UniqueKey()));
}

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentIndex;
  final Function(int) onTap;
  final Widget? bottomSheet;

  const BaseScaffold({
    Key? key,
    required this.title,
    required this.body,
    required this.currentIndex,
    required this.onTap,
    this.bottomSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.place),
              label: 'Tracking',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'GPX',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_file),
              label: 'Geofence',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.black),
        ],
      ),
      bottomSheet: bottomSheet,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yavapai County Search & Rescue',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            backgroundColor: Colors.black),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Yavapai County Search & Rescue',
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  fixedSize: const Size(200, 60),
                ),
                child: const Text('Start Live Tracking',
                    style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LiveTrackingPage()),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  fixedSize: const Size(200, 60),
                ),
                child: const Text('Convert to GPX',
                    style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConvertToGpxPage()),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  fixedSize: const Size(200, 60),
                ),
                child: const Text('Geofence Tracking',
                    style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ImportGeofencePage()),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  fixedSize: const Size(200, 60),
                ),
                child: const Text('Settings', style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BluetoothSettingsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LiveTrackingPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ConvertToGpxPage()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ImportGeofencePage()),
          );
        } else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const BluetoothSettingsPage()),
          );
        }
      },
    );
  }
}

class DogInfo {
  final String dogName;
  final String devicePrefix;
  final String deviceId;
  bool isChecked;

  DogInfo({
    required this.dogName,
    required this.devicePrefix,
    required this.deviceId,
    this.isChecked = false,
  });
}

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({Key? key}) : super(key: key);

  @override
  LiveTrackingPageState createState() => LiveTrackingPageState();
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

final List<DogInfo> _dogInfoList = [];
String _bluetoothData = ''; // add this variable to hold the Bluetooth data
late StreamController<String> _bluetoothDataStream;

class LiveTrackingPageState extends State<LiveTrackingPage> {
  final TextEditingController _dogNameController = TextEditingController();
  final TextEditingController _callSignController = TextEditingController();
  final TextEditingController _deviceIdController = TextEditingController();
  BluetoothManager? _bluetoothManager;
  bool _allFieldsFilled = false;

  void _checkFieldsFilled() {
    setState(() {
      _allFieldsFilled = _dogNameController.text.isNotEmpty &&
          _callSignController.text.isNotEmpty &&
          _deviceIdController.text.isNotEmpty;
    });
  }

  bool _anyCheckboxChecked = false;

  void _onCheckboxChanged(bool? value, int index) {
    setState(() {
      _dogInfoList[index].isChecked = value ?? false;
      _anyCheckboxChecked = _dogInfoList.any((dogInfo) => dogInfo.isChecked);
    });
  }

  void _submitDogInfo() {
    DogInfo dogInfo = DogInfo(
      dogName: _dogNameController.text,
      devicePrefix: _callSignController.text,
      deviceId: _deviceIdController.text,
    );

    setState(() {
      _dogInfoList.add(dogInfo);
      _dogNameController.clear();
      _callSignController.clear();
      _deviceIdController.clear();
      _allFieldsFilled = false;
    });
  }

  Timer? _positionUpdatesTimer;
  // ignore: unused_field
  bool _trackingStarted = false;

  void _startTrackingSelectedDogs() async {
    _trackingStarted = true;
    // Replace 'path/to/coordinates.txt' with the actual file path.
    List<Map<String, double>> coordinates =
        await readCoordinatesFromFile('assets/S2PT.txt');
    int currentIndex = 0;

    _positionUpdatesTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      for (DogInfo dogInfo in _dogInfoList) {
        if (dogInfo.isChecked) {
          sendPositionUpdate(
            dogInfo.devicePrefix,
            dogInfo.deviceId,
            coordinates[currentIndex]['lat']!,
            coordinates[currentIndex]['lon']!,
          );
        }
      }
      currentIndex = (currentIndex + 1) % coordinates.length;
    });
  }

  void _stopTrackingSelectedDogs() {
    _positionUpdatesTimer?.cancel();
    _trackingStarted = false;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Live Tracking',
      currentIndex: 1,
      onTap: (index) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            if (index == 0) {
              return const HomePage();
            } else if (index == 1) {
              return const LiveTrackingPage();
            } else if (index == 2) {
              return const ConvertToGpxPage();
            } else if (index == 3) {
              return const ImportGeofencePage();
            } else if (index == 4) {
              return const BluetoothSettingsPage();
            } else {
              return const HomePage();
            }
          }),
        );
      },
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dog Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dogNameController,
              onChanged: (value) => _checkFieldsFilled(),
              decoration: const InputDecoration(
                labelText: 'Dog Name:',
              ),
            ),
            TextField(
              controller: _callSignController,
              onChanged: (value) => _checkFieldsFilled(),
              decoration: const InputDecoration(
                labelText: 'Device Prefix:',
              ),
            ),
            TextField(
              controller: _deviceIdController,
              onChanged: (value) => _checkFieldsFilled(),
              decoration: const InputDecoration(
                labelText: 'Device ID:',
              ),
            ),
            if (_allFieldsFilled)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: _submitDogInfo,
                  child: const Text('OK'),
                ),
              ),
            const SizedBox(height: 32),
            for (int i = 0; i < _dogInfoList.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _dogInfoList[i].isChecked,
                        onChanged: (bool? value) {
                          _onCheckboxChanged(value, i);
                        },
                      ),
                      Text(_dogInfoList[i].dogName,
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                          '${_dogInfoList[i].devicePrefix}-${_dogInfoList[i].deviceId}',
                          style: const TextStyle(fontSize: 20)),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _dogInfoList.removeAt(i);
                          });
                        },
                      ),
                    ],
                  ),
                  if (i == 0)
                    StreamBuilder<String>(
                      stream: _bluetoothDataStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            'Dog Position: ${snapshot.data}',
                            style: const TextStyle(fontSize: 18),
                          );
                        } else {
                          return const Text(
                            'No data received',
                            style: TextStyle(fontSize: 18),
                          );
                        }
                      },
                    ),
                  Row(
                    children: [
                      const Text(
                        'LED:  ',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 18,
                        width: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_bluetoothManager?._connected ?? false) {
                              await _bluetoothManager!.ledcontrol('ON');
                            } else {
                              print('Bluetooth connection is not established.');
                            }
                          },
                          child:
                              const Text('ON', style: TextStyle(fontSize: 8)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 18,
                        width: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_bluetoothManager?._connected ?? false) {
                              await _bluetoothManager!.ledcontrol('OFF');
                            } else {
                              print('Bluetooth connection is not established.');
                            }
                          },
                          child:
                              const Text('OFF', style: TextStyle(fontSize: 8)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            if (_anyCheckboxChecked)
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _startTrackingSelectedDogs();
                    },
                    child: const Text('Start Tracking'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed:
                        _anyCheckboxChecked ? _stopTrackingSelectedDogs : null,
                    child: const Text('Stop Tracking'),
                  ),
                ],
              )),
          ],
        ),
      ),
    );
  }
}

Future<String> getDownloadsPath() async {
  final directory = await getDownloadsDirectory();
  return directory?.path ?? '';
}

class ConvertToGpxPage extends StatefulWidget {
  const ConvertToGpxPage({Key? key}) : super(key: key);

  @override
  _ConvertToGpxPageState createState() => _ConvertToGpxPageState();
}

class _ConvertToGpxPageState extends State<ConvertToGpxPage> {
  String? _fileName;
  final int _currentIndex = 2;
  bool _isConversionSuccessful = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _fileName = file.name;
      });

      String? filePath = file.path;
      if (filePath == null) {
        // Handle case where file path is null
        return;
      }

      String fileName = file.name;
      String gpxFileName = '${fileName.replaceAll('.txt', '')}.gpx';

      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        // Handle case where external storage directory is null
        return;
      }

      String gpxFilePath = '${externalDir.path}/Download/$gpxFileName';
      gpxFilePath = gpxFilePath.replaceAll(
          '/Android/data/com.example.ycsr_app/files', '');

      await convertToGpx(filePath, gpxFilePath);

      try {
        await convertToGpx(filePath, gpxFilePath);
        setState(() {
          _isConversionSuccessful = true;
        });
        print('GPX file saved at $gpxFilePath');
      } catch (e) {
        setState(() {
          _isConversionSuccessful = false;
        });
        print('Failed to convert GPS data to GPX file: $e');
      }
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Convert to GPX',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please choose a file containing GPS data to convert to GPX:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Upload File'),
            ),
            if (_fileName != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Selected file: $_fileName'),
              ),
          ],
        ),
      ),
      bottomSheet: _fileName != null
          ? Container(
              padding: const EdgeInsets.all(16.0),
              color: _isConversionSuccessful ? Colors.green : Colors.red,
              child: Text(
                _isConversionSuccessful
                    ? 'GPS data was successfully converted to a GPX file and saved! It is saved in the Downloads folder.'
                    : 'GPS data was NOT successfully converted to a GPX file and saved!',
                style: const TextStyle(color: Colors.white),
              ),
            )
          : null,
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LiveTrackingPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ConvertToGpxPage()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ImportGeofencePage()),
          );
        } else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const BluetoothSettingsPage()),
          );
        }
      },
    );
  }
}

class ImportGeofencePage extends StatefulWidget {
  const ImportGeofencePage({Key? key}) : super(key: key);

  @override
  _ImportGeofencePageState createState() => _ImportGeofencePageState();
}

class _ImportGeofencePageState extends State<ImportGeofencePage> {
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _fileName = file.name;
      });
      //Add logic for creating GeoFence
      // String geoJsonString = String.fromCharCodes(file.bytes!);
      // print('GeoJSON string: $geoJsonString');
      // List<LatLng> polygon = parseGeoJsonToPolygon(geoJsonString);

      // String filePath = 'assets/S2PT.txt';
      // List<Map<String, double>> coordinates =
      //     await readCoordinatesFromFile(filePath);

      // await checkCoordinates(coordinates, polygon);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Import GeoFence',
      currentIndex: 3,
      onTap: (index) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            if (index == 0) {
              return const HomePage();
            } else if (index == 1) {
              return const LiveTrackingPage();
            } else if (index == 2) {
              return const ConvertToGpxPage();
            } else if (index == 3) {
              return const ImportGeofencePage();
            } else if (index == 4) {
              return const BluetoothSettingsPage();
            } else {
              return const HomePage();
            }
          }),
        );
      },
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please choose a GeoJSON file to create a GeoFence:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Import GeoJSON'),
            ),
            if (_fileName != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Selected file: $_fileName'),
              ),
          ],
        ),
      ),
      bottomSheet: _fileName != null
          ? Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.green,
              child: const Text(
                'Detecting if dog is within the GeoFence...',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }
}

class BluetoothSettingsPage extends StatefulWidget {
  const BluetoothSettingsPage({super.key});

  @override
  _BluetoothSettingsPageState createState() => _BluetoothSettingsPageState();
}

class _BluetoothSettingsPageState extends State<BluetoothSettingsPage> {
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? _connection;
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  String _dataReceived = '';
  final audioCache = AudioCache();
  String _lastBluetoothData = '';

  Future<void> requestBluetoothPermissions() async {
    List<Permission> permissions = [
      Permission.bluetooth,
      Permission.locationWhenInUse,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
    ];

    for (Permission permission in permissions) {
      PermissionStatus status = await permission.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        PermissionStatus newStatus = await permission.request();
        print('$permission: $newStatus');
      }
    }
  }

  Future<void> _initBluetooth() async {
    BluetoothState state = await FlutterBluetoothSerial.instance.state;
    if (state == BluetoothState.STATE_OFF) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Bluetooth'),
            content: const Text('Please turn on Bluetooth.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

// Function to discover nearby devices
  Future<void> _getPairedDevices() async {
    print('Discover Paired Devices button pressed');
    await requestBluetoothPermissions();
    PermissionStatus status = await Permission.bluetooth.status;
    if (status.isGranted) {
      print('Bluetooth permission is granted');
      List<BluetoothDevice> devices = await _bluetooth.getBondedDevices();
      print('Bonded devices count: ${devices.length}');
      setState(() {
        _devicesList = devices;
      });
    } else {
      print('Bluetooth permission is not granted.');
    }
  }

  Future<void> loadSound() async {
    await audioCache.load('Sound.mp3');
  }

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    _initBluetooth();
    _bluetoothDataStream = StreamController<String>.broadcast(
      onListen: () {
        _bluetoothDataStream.add(_bluetoothData);
      },
    );
    loadSound().then((_) {
      audioCache.play('Sound.mp3');
    });
  }

  // Function to update bluetooth
  void _updateBluetoothData(String data) {
    setState(() {
      _bluetoothData = data;
      _bluetoothDataStream.add(_bluetoothData);
      if (_bluetoothData == 'Sitting' && _lastBluetoothData == 'Moving') {
        audioCache.play('Sound.mp3');
      }
      _lastBluetoothData = _bluetoothData;
    });
  }

  // Function to connect to a device
  Future<void> _connectToDevice(BluetoothDevice device) async {
    if (_connected) {
      if (_connection != null) {
        _connection!.close();
      }
    }
    _connection = await BluetoothConnection.toAddress(device.address);
    setState(() {
      _connected = true;
      _device = device;
    });

    _connection?.input?.listen((data) {
      setState(() {
        _dataReceived = String.fromCharCodes(data);
        print('Received data: $_dataReceived');
        _updateBluetoothData(_dataReceived);
      });
    }).onDone(() {
      setState(() {
        _connected = false;
      });
    });
  }

  @override
  void dispose() {
    // Don't forget to close the stream controller when the widget is disposed
    _bluetoothDataStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Bluetooth Settings',
      currentIndex: 4,
      onTap: (index) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            if (index == 0) {
              return const HomePage();
            } else if (index == 1) {
              return const LiveTrackingPage();
            } else if (index == 2) {
              return const ConvertToGpxPage();
            } else if (index == 3) {
              return const ImportGeofencePage();
            } else if (index == 4) {
              return const BluetoothSettingsPage();
            } else {
              return const HomePage();
            }
          }),
        );
      },
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Paired Devices',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _devicesList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_devicesList[index].name ?? 'Unknown Device'),
                  subtitle: Text(_devicesList[index].address),
                  onTap: () {
                    _connectToDevice(_devicesList[index]);
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await requestBluetoothPermissions();
                  _getPairedDevices();
                },
                child: const Text('Discover Paired Devices'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _connected
                    ? 'Connected to: ${_device!.name}'
                    : 'Not connected to any device',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _connected
          ? Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.green,
              child: const Text(
                'Connected to Device!',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }
}

class BluetoothManager {
  final BluetoothConnection _connection;
  final bool _connected;

  BluetoothManager(this._connection) : _connected = true;

  Future<void> ledcontrol(String data) async {
    if (_connected) {
      try {
        Uint8List bytes = Uint8List.fromList(utf8.encode(data));
        _connection.output.add(bytes);
        print('LED control command sent: $data');
      } catch (e) {
        print('Failed to send LED control command: $e');
      }
    } else {
      print('Not connected to any device');
    }
  }
}
