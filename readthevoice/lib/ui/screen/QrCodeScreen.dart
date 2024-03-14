/*
help :
    - https://www.youtube.com/watch?v=yj4aNEOun6I*
    - https://www.youtube.com/watch?v=pKGTKdS8lAs
    - https://pub.dev/packages/qr_code_scanner
*/

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:readthevoice/ui/screen/StreamScreen.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  String result = "";

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code!;

        // Navigate to meeting screen
        String meetingId = result;

        if(meetingId.isNotEmpty && meetingId.trim() != "") {
          controller.pauseCamera();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamScreen(meetingId: meetingId),
            ),
          );

          // dispose();
        }
      });
    });
  }

  // Gets the url like: "readthevoice/<meetingId>"
  // Gotta return to the stream screen ! based on the meetingId => pass the meetingId to the screen.
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller != null) {
        try {
          await controller?.resumeCamera(); // Attempt to resume even if paused
        } catch (error) {
          print("Error resuming camera: $error");

          // if (kDebugMode) {
          //   print("Error resuming camera: $error");
          // } // Log for debugging
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    controller?.resumeCamera();

    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ),
      ],
    );

    // return Scaffold(
    //     body: Column(
    //       children: [
    //         Center(
    //           child: SizedBox(
    //             width: 300,
    //             height: 300,
    //             child: QRView(
    //               key: qrKey,
    //               onQRViewCreated: _onQRViewCreated,
    //             ),
    //           ),
    //         ),
    //       ],
    //     )
    // );
  }
}

/*

class QrCodeState extends ChangeNotifier {
  String result = "";
  bool cameraPaused = false;

  void updateResult(String newResult) {
    result = newResult;
    notifyListeners();
  }

  void setCameraPaused(bool paused) {
    cameraPaused = paused;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QrCodeState(),
      child: MaterialApp(
        home: QrCodeScreen(),
      ),
    );
  }
}

class QrCodeScreen extends StatefulWidget {
@override
State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
QRViewController? controller;

 final QrCodeState _qrCodeState = Provider.of<QrCodeState>(context); // Access state

 @override
 void dispose() {
   controller?.dispose();
   super.dispose();
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     // ...
     body: Center(
       child: SizedBox(
         width: 300,
         height: 300,
         child: QRView(
           key: qrKey,
           onQRViewCreated: _onQRViewCreated,
         ),
       ),
     ),
   );
 }

 void _onQRViewCreated(QRViewController controller) {
   this.controller = controller;
   controller.scannedDataStream.listen((scanData) {
     setState(() {
       _qrCodeState.updateResult(scanData.code!); // Update state object
       // ... (navigation and data passing logic)

       // Pause the camera before navigation
       _qrCodeState.setCameraPaused(true);
       controller.pauseCamera();
     });
   });
 }

 @override
 void didChangeDependencies() {
   super.didChangeDependencies();
   WidgetsBinding.instance.addPostFrameCallback((_) async {
     if (controller != null && !_qrCodeState.cameraPaused) {
       // Resume the camera only if not already paused (based on state)
       await controller.resumeCamera();
     }
   });
 }

}

 */


