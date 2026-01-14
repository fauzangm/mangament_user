import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangament_acara/presentation/bloc/undangan/undangan_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mangament_acara/core/themes/AppColors.dart';

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

  void _handleQRResult(String raw) {
    final parts = raw.split('|');

    if (parts.isEmpty) {
      _showErrorSnackBar('QR tidak valid');
      return;
    }

    final type = parts[0].toLowerCase();

    try {
      if (type == 'checkin' && parts.length == 3) {
        final id = int.parse(parts[1]);
        final kode = parts[2];

        context.read<UndanganBloc>().add(CheckinUndangan(id: id, kode: kode));
      } else if (type == 'presensi' && parts.length == 5) {
        final id = int.parse(parts[1]);
        final tanggal = parts[2];
        final sesi = parts[3];
        final token = parts[4];

        context.read<UndanganBloc>().add(
          PresensiUndangan(id: id, tanggal: tanggal, sesi: sesi, token: token),
        );
      } else {
        _showErrorSnackBar('Format QR tidak dikenali');
      }
    } catch (e) {
      _showErrorSnackBar('QR tidak valid');
    }
  }

  Future<void> _startScanning() async {
    try {
      setState(() {
        isScanning = true;
      });
      await controller.start();
    } catch (e) {
      print('Error starting scanner: $e');
      _showErrorSnackBar(
        'Failed to start camera. Please check camera permissions.',
      );
      setState(() {
        isScanning = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
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
        content: const Text(
          'Please enable camera permission in your device settings to scan QR codes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // You can manually guide user to settings
              _showErrorSnackBar(
                'Please go to Settings > Privacy > Camera to enable permission',
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        controller.stop();

        final result = barcode.rawValue!;
        setState(() {
          scannedResult = result;
          isScanning = false;
        });

        _handleQRResult(result);
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
    return BlocListener<UndanganBloc, UndanganState>(
      listener: (context, state) {
        if (state is UndanganSuccesPost && state.isSucces) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berhasil diproses'),
              backgroundColor: Colors.green,
            ),
          );

          // ⬇️ KIRIM RESULT KE BERANDA
          Navigator.of(context).pop(true); // balik ke beranda
        }

        if (state is UndanganError) {
          _showErrorSnackBar(state.message);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(28),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'QR Presence',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Scan QR Code untuk Presensi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: isScanning
                                  ? Stack(
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
                                    )
                                  : const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.qr_code_scanner,
                                            size: 72,
                                            color: AppColors.textSecondary,
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            'Tekan tombol di bawah untuk mulai scan',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.textSecondary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (scannedResult.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.25),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Last Scan Result',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  scannedResult,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
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
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              isScanning ? 'Stop Scanning' : 'Start Scanning',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      ..color = AppColors.primary
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
        Path()..addRect(
          Rect.fromLTWH(cutOutLeft, cutOutTop, cutOutSize, cutOutSize),
        ),
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
      ..color = AppColors.primary
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
