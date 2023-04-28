// ignore_for_file: library_private_types_in_public_api, avoid_print, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

import 'main.dart';

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

  // Function to update bluetooth
  void _updateBluetoothData(String data) {
    setState(() {
      _dataReceived = data;
    });
  }

  // Function to connect to a device
  void _connectToDevice(BluetoothDevice device) async {
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
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    _initBluetooth();
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
    );
  }
}
