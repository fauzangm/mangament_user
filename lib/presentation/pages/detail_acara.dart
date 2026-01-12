import 'package:flutter/material.dart';
import 'package:mangament_acara/core/themes/AppColors.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DetailAcaraPage extends StatefulWidget {
  final Map<String, dynamic> acaraData;
  
  const DetailAcaraPage({super.key, required this.acaraData});

  @override
  State<DetailAcaraPage> createState() => _DetailAcaraPageState();
}

class _DetailAcaraPageState extends State<DetailAcaraPage> {
  bool _isTermsExpanded = false;
  late final LatLng _eventLocation;

  @override
  void initState() {
    super.initState();
    final latRaw = widget.acaraData['lat'];
    final lngRaw = widget.acaraData['lng'];
    final lat = (latRaw is num) ? latRaw.toDouble() : -6.2088;
    final lng = (lngRaw is num) ? lngRaw.toDouble() : 106.8456;
    _eventLocation = LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 32),
                decoration: const BoxDecoration(
                  gradient: AppColors.backgroundGradient,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Event Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Image
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.event,
                              size: 80,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Event Title
                        Text(
                          widget.acaraData['title'] ?? 'Event Title',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Organization
                        Text(
                          widget.acaraData['organization'] ?? 'Organization Name',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Event Details
                        _buildDetailRow(
                          Icons.calendar_today,
                          widget.acaraData['date'] ?? 'Event Date',
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          Icons.location_on,
                          widget.acaraData['location'] ?? 'Event Location',
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          Icons.access_time,
                          widget.acaraData['time'] ?? 'Event Time',
                        ),
                        const SizedBox(height: 24),
                        
                        // Description
                        Text(
                          widget.acaraData['description'] ?? 'Event description will appear here. This is a placeholder text that shows how the content will be displayed in the actual application.',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Google Maps
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: _eventLocation,
                                initialZoom: 15,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.pinchZoom |
                                      InteractiveFlag.drag,
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'mangament_acara',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: _eventLocation,
                                      width: 46,
                                      height: 46,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Terms & Conditions
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Terms Header
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isTermsExpanded = !_isTermsExpanded;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Terms & Conditions',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Icon(
                                        _isTermsExpanded 
                                          ? Icons.keyboard_arrow_up 
                                          : Icons.keyboard_arrow_down,
                                        color: AppColors.primary,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Terms Content
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: _isTermsExpanded
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      child: const Text(
                                        'By accepting this invitation, you agree to:\n\n'
                                        '1. Arrive on time for the event\n'
                                        '2. Follow all event guidelines and protocols\n'
                                        '3. Respect other participants and organizers\n'
                                        '4. Maintain professional conduct throughout\n'
                                        '5. Provide feedback after the event\n\n'
                                        'Failure to comply with these terms may result in '
                                        'restricted access to future events.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                          height: 1.5,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Accept',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Decline',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}