import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PresensiPage extends StatefulWidget {
  const PresensiPage({super.key});

  @override
  State<PresensiPage> createState() => _PresensiPageState();
}

class _PresensiPageState extends State<PresensiPage> {
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool isScanning = false;
  String scannedResult = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _startScanning() async {
    try {
      setState(() {
        isScanning = true;
      });
      await controller.start();
    } catch (e) {
      print('Error starting scanner: $e');
      _showErrorSnackBar('Failed to start camera. Please check camera permissions.');
      setState(() {
        isScanning = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Settings',
          textColor: Colors.white,
          onPressed: () {
            // Note: You might need to add app_settings package for this
            _showPermissionDialog();
          },
        ),
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text('Please enable camera permission in your device settings to scan QR codes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // You can manually guide user to settings
              _showErrorSnackBar('Please go to Settings > Privacy > Camera to enable permission');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          scannedResult = barcode.rawValue!;
          isScanning = false;
        });
        controller.stop();
        _showResultDialog();
        break;
      }
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Result'),
        content: Text('QR Code: $scannedResult'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                isScanning = true;
              });
              controller.start();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presensi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Scan QR Code untuk Presensi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (isScanning)
              Expanded(
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: controller,
                      onDetect: _onDetect,
                    ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: QRScannerOverlayPainter(),
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 100,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Tap the button below to start scanning',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (scannedResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last Scan Result:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      scannedResult,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isScanning) {
                  controller.stop();
                  setState(() {
                    isScanning = false;
                  });
                } else {
                  _startScanning();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isScanning ? 'Stop Scanning' : 'Start Scanning',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QRScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final cutOutSize = 250.0;
    final cutOutLeft = (size.width - cutOutSize) / 2;
    final cutOutTop = (size.height - cutOutSize) / 2;

    // Draw dark overlay
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRect(Rect.fromLTWH(cutOutLeft, cutOutTop, cutOutSize, cutOutSize)),
      ),
      paint,
    );

    // Draw border
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cutOutLeft, cutOutTop, cutOutSize, cutOutSize),
        const Radius.circular(10),
      ),
      borderPaint,
    );

    // Draw corner markers
    final cornerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final cornerLength = 30.0;
    
    // Top-left corner
    canvas.drawLine(
      Offset(cutOutLeft, cutOutTop + cornerLength),
      Offset(cutOutLeft, cutOutTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutOutLeft, cutOutTop),
      Offset(cutOutLeft + cornerLength, cutOutTop),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(cutOutLeft + cutOutSize - cornerLength, cutOutTop),
      Offset(cutOutLeft + cutOutSize, cutOutTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutOutLeft + cutOutSize, cutOutTop),
      Offset(cutOutLeft + cutOutSize, cutOutTop + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(cutOutLeft, cutOutTop + cutOutSize - cornerLength),
      Offset(cutOutLeft, cutOutTop + cutOutSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutOutLeft, cutOutTop + cutOutSize),
      Offset(cutOutLeft + cornerLength, cutOutTop + cutOutSize),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(cutOutLeft + cutOutSize - cornerLength, cutOutTop + cutOutSize),
      Offset(cutOutLeft + cutOutSize, cutOutTop + cutOutSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutOutLeft + cutOutSize, cutOutTop + cutOutSize - cornerLength),
      Offset(cutOutLeft + cutOutSize, cutOutTop + cutOutSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}