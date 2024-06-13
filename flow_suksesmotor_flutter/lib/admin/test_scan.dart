// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final cameras = await availableCameras();
//   final firstCamera = cameras.first;

//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: OCRScreen(camera: firstCamera),
//     ),
//   );
// }

// class OCRScreen extends StatefulWidget {
//   final CameraDescription camera;

//   OCRScreen({required this.camera});

//   @override
//   _OCRScreenState createState() => _OCRScreenState();
// }

// class _OCRScreenState extends State<OCRScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   bool _isScanning = false;
//   String _recognizedText = '';

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(
//       widget.camera,
//       ResolutionPreset.high,
//     );

//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _scanText() async {
//     try {
//       setState(() {
//         _isScanning = true;
//       });

//       await _initializeControllerFuture;
//       final image = await _controller.takePicture();

//       final inputImage = InputImage.fromFilePath(image.path);
//       final textRecognizer = TextRecognizer();
//       final RecognizedText recognizedText =
//           await textRecognizer.processImage(inputImage);

//       setState(() {
//         _recognizedText = recognizedText.text;
//         _isScanning = false;
//       });
//     } catch (e) {
//       print(e);
//       setState(() {
//         _isScanning = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('OCR Scanner')),
//       body: Column(
//         children: [
//           Expanded(
//             child: FutureBuilder<void>(
//               future: _initializeControllerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return CameraPreview(_controller);
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             ),
//           ),
//           if (_isScanning) CircularProgressIndicator(),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               _recognizedText,
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: _isScanning ? null : _scanText,
//               child: Text('Scan Text'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
