import 'package:flow_suksesmotor/services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class OcrScanner extends StatefulWidget {
  final int orderId;
  final String workerName;
  final List<Map<String, dynamic>> items;

  OcrScanner({
    required this.orderId,
    required this.workerName,
    required this.items, // Required parameter
  });
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
      } else if (cameraStatus.isPermanentlyDenied ||
          storageStatus.isPermanentlyDenied) {
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

  Future<void> updateQuantityArrived(
      int orderId, Map<String, dynamic> item) async {
    var response = await OrderServices().updateQuantityArrived(orderId, item);

    if (response.statusCode == 200) {
      // Successfully updated
      print('Order item updated successfully!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order item updated successfully!')),
      );
    } else {
      // Failed to update
      print('Failed to update order item: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order item.')),
      );
    }
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

      // Load the captured image
      final bytes = await File(image.path).readAsBytes();
      final originalImage = img.decodeImage(bytes);

      if (originalImage == null) {
        print('Error: Unable to decode image.');
        return;
      }

      // Determine the dimensions of the overlay box

      final overlayHeight = MediaQuery.of(context).size.height * 0.1;

// Determine the position of the overlay box
      final overlayTopMargin = MediaQuery.of(context).size.height * 0.4;

// Calculate crop area based on overlay position and dimensions
      int cropX =  (originalImage.width * 0.1).toInt();; // Starting X position of crop
      int cropY = overlayTopMargin.toInt(); // Starting Y position of crop
      int cropWidth =
          (originalImage.width * 0.9).toInt(); // Width of the crop area
      int cropHeight = (overlayHeight *
              originalImage.height /
              MediaQuery.of(context).size.height)
          .toInt(); // Height of the crop area

// Ensure the crop area fits within the image dimensions
      cropY = cropY.clamp(
          0,
          originalImage.height -
              cropHeight); // Clamp Y to stay within image bounds

// Crop the image
      final croppedImage = img.copyCrop(
        originalImage,
        x: cropX,
        y: cropY,
        width: cropWidth,
        height: cropHeight,
      );

      // Save the cropped image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/cropped_image.png';
      File(tempPath).writeAsBytesSync(img.encodePng(croppedImage));

      // Create an InputImage from the cropped file
      final inputImage = InputImage.fromFilePath(tempPath);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      String scannedText = recognizedText.text;
      if (scannedText.isNotEmpty) {
        bool foundMatch = false;
        int matchIndex = -1; // Initialize with -1 indicating no match
        var item = null;
        
// Check each item in widget.items
        for (int i = 0; i < widget.items.length; i++) {
          item = widget.items[i];
          if (scannedText == item['name'] || scannedText == item['custom_id']) {
            foundMatch = true;
            matchIndex = i; // Store the index of the matching item
            break; // Exit loop if match found
          }
        }

        if (foundMatch) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(item['custom_id']+'\n'+item['name']+'\n'+item['Quantity_ordered'].toString()+'\nEnter Quantity Arrived'),
              content: TextField(
                controller: TextEditingController(
                  text: item['Incoming_Quantity'].toString(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      item['Incoming_Quantity'] = int.parse(value);
                    });
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: ()async  {
                    final itemToUpdate = {
                      'custom_id': item['custom_id'],
                      'name': item['name'],
                      'brand': item['brand'],
                      'Quantity_ordered': item['Quantity_ordered'],
                      'Incoming_Quantity': item['Incoming_Quantity'],
                      'checker_barang': widget.workerName,
                    };

                    await updateQuantityArrived(widget.orderId, itemToUpdate);
                    Navigator.pop(context);
                    Navigator.pop(context, true);  
                    
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('No Match Found'),
              content:
                  Text(scannedText + '\nScanned text does not match any item.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Empty Scan'),
            content: Text('There is nothing scanned.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
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
                // Camera preview
                CameraPreview(_cameraController!),

                // Overlay box
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2,
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),

                // Scan button
                Positioned(
                  bottom: 50.0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: _scanText,
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16.0),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 30.0,
                          color: Colors.black,
                        ),
                      ),
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
