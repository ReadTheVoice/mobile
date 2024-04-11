
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCheckHelper {
  ConnectivityCheckHelper._();

  static final _instance = ConnectivityCheckHelper._();
  static ConnectivityCheckHelper get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialize() async {
    var test = await _connectivity.checkConnectivity();
    print("test initialize ConnectivityCheckHelper".toUpperCase());
    print(test);
    
    List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    _checkStatus(result[0]);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result[0]);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}