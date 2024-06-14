import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class OcrScanner extends StatefulWidget {
  @override
  _OcrScannerState createState() => _OcrScannerState();
}

class _OcrScannerState extends State<OcrScanner> {
  CameraController? _cameraController;
  late CameraDescription _camera;
  bool _isCameraInitialized = false;
  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }
  
  Future<void> _requestPermissions() async {
  var cameraStatus = await Permission.camera.request();
  var storageStatus = await Permission.storage.request();

  if (cameraStatus.isGranted && storageStatus.isGranted) {
    _initializeCamera();
  } else {
    if (cameraStatus.isDenied || storageStatus.isDenied) {
      _showPermissionDialog(
        'Permissions Required',
        'Camera and storage permissions are required to use this app.',
      );
    } else if (cameraStatus.isPermanentlyDenied || storageStatus.isPermanentlyDenied) {
      _showPermissionDialog(
        'Permissions Permanently Denied',
        'Please enable camera and storage permissions from the app settings.',
      );
    }
  }
}


  void _showPermissionDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

 Future<void> _initializeCamera() async {
  try {
    final cameras = await availableCameras();
    _camera = cameras.first;

    _cameraController = CameraController(_camera, ResolutionPreset.high);
    await _cameraController?.initialize();

    setState(() {
      _isCameraInitialized = true;
    });
  } catch (e) {
    print('Error initializing camera: $e');
  }
}


  Future<void> _scanText() async {
  if (_cameraController == null || !_cameraController!.value.isInitialized) {
    print('Error: Camera controller is not initialized.');
    return;
  }

  try {
    XFile? image = await _cameraController!.takePicture();
    if (image == null) {
      print('Error: Failed to capture image.');
      return;
    }

    final inputImage = InputImage.fromFilePath(image.path);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    String scannedText = recognizedText.text;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Scanned Text'),
        content: Text(scannedText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  } catch (e) {
    print('Error scanning text: $e');
  }
}


  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('OCR Scanner'),
    ),
    body: _isCameraInitialized
        ? Stack(
            children: [
              CameraPreview(_cameraController!),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _scanText,
                    child: Text('Scan Text'),
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          ),
  );
}
}
