import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';
import 'dart:math';

num r0=-65;
num n=3;

Map <String,num>devices={"1":1}; //{'uid':'','rssi':123};
List<String> whitelist;
/*print('Map :${m}');
Map <String,String>m={'name':'Tom','Id':'E1001'};
print('Map :${m}');*/

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLE Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter BLE Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _rssiString;

  @override
  void initState() {
    _rssiString = "-1";
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getRSSI());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(_rssiString),
      ),
    );
  }

  String getHistory(){
    String history="";
    devices.forEach((k,v) => history=history+ " MAC: "+k+" RSSI: "+v.toString()+ " distance: "+pow(10.0, (r0-v)/(10.0*n)).toString()+"\n");
    return history;
  }

  void _getRSSI() {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    // Start scanning
    if(devices.isNotEmpty)
      devices.clear();
    flutterBlue.startScan(timeout: Duration(seconds: 3));
    var subscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
        devices[r.device.id.toString()]= r.rssi;
        setState(() {
          _rssiString=getHistory();
          //num distance=pow(10.0, (r0-r.rssi)/(10.0*n));
          //_rssiString = _rssiString + "Device" + r.device.name.toString() + " RSSI "+r.rssi.toString()+" distance: "+distance.toString()+"\n";
        });
      }
    });

    // Stop scanning
    //flutterBlue.stopScan();
    //subscription.cancel();
  }
}

/*int async boh(){
  List<BluetoothService> services = await device.discoverServices();
  services.forEach((service) {
    var characteristics = service.characteristics;
    for(BluetoothCharacteristic c in characteristics) {
      List<int> value = await c.read();
      print(value);
    }
  });
}*/
/*int boh() {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  // Start scanning
  flutterBlue.startScan(timeout: Duration(seconds: 20));
  int valore = -1;
// Listen to scan results
  var subscription = flutterBlue.scanResults.listen((results) {
    for (ScanResult r in results) {
      print('${r.device.name} found! rssi: ${r.rssi}');
      valore = r.rssi;
    }
  });

// Stop scanning
  flutterBlue.stopScan();
  return valore;
}*/
