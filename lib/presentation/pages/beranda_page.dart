import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangament_acara/core/themes/AppColors.dart';
import '../bloc/undangan/undangan_bloc.dart';
import '../models/undangan.dart';
import '../widgets/neumorphic_button.dart';
import 'presensi_page.dart';
import 'detail_acara.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  void _showQRScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PresensiPage(),
      ),
    );
  }

  void _navigateToDetail(Undangan undangan) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailAcaraPage(
          acaraData: {
            'title': undangan.title,
            'organization': undangan.organization,
            'date': undangan.date,
            'location': undangan.location,
            'time': '10:00 - 12:00',
            'description': undangan.description ?? 'Join us for this amazing event where we will discuss the latest trends in digital transformation and network with industry experts.',
            'status': undangan.status,
            'lat': -6.2088,
            'lng': 106.8456,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => UndanganBloc()..add(LoadUndangan()),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.glossyGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // Content di belakang
                      BlocBuilder<UndanganBloc, UndanganState>(
                        builder: (context, state) {
                          if (state is UndanganLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  AppColors.primary,
                                ),
                              ),
                            );
                          }

                          if (state is UndanganError) {
                            return Center(
                              child: Text(
                                'Error: ${state.message}',
                                style: const TextStyle(color: AppColors.error),
                              ),
                            );
                          }

                          if (state is UndanganLoaded) {
                            return _buildInvitationContent(state.undangans);
                          }

                          return const Center(child: Text('No invitations'));
                        },
                      ),
                      // Header di atas
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: _buildTopHeader(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingQRButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTopHeader() {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 48, 20, 32),
    decoration: const BoxDecoration(
      gradient: AppColors.backgroundGradient,
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(28),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'My Invitations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '3 invitations',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.logout,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    ),
  );
}


  Widget _buildInvitationContent(List<Undangan> undangans) {
    final pendingUndangans = undangans
        .where((u) => u.status == 'pending')
        .toList();
    final confirmedUndangans = undangans
        .where((u) => u.status == 'confirmed')
        .toList();
    final declinedUndangans = undangans
        .where((u) => u.status == 'declined')
        .toList();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 180), // Tambahkan padding atas untuk header
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Pending',
                    pendingUndangans.length,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Confirmed',
                    confirmedUndangans.length,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Declined',
                    declinedUndangans.length,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Requires Action Section
            if (pendingUndangans.isNotEmpty) ...[
              _buildSectionHeader('REQUIRES ACTION (${pendingUndangans.length})'),
              const SizedBox(height: 12),
              ...pendingUndangans
                  .map((undangan) => _buildUndanganCard(undangan))
                  .toList(),
              const SizedBox(height: 24),
            ],

            // Confirmed Section
            if (confirmedUndangans.isNotEmpty) ...[
              _buildSectionHeader('CONFIRMED (${confirmedUndangans.length})'),
              const SizedBox(height: 12),
              ...confirmedUndangans
                  .map((undangan) => _buildUndanganCard(undangan))
                  .toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildUndanganCard(Undangan undangan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      undangan.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      undangan.organization,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(undangan.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  undangan.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(undangan.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                undangan.date,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                undangan.location,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _navigateToDetail(undangan);
                },
                child: const Text(
                  'View Details >',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'declined':
        return Colors.red;
      default:
        return Colors.red;
    }
  }

  Widget _buildFloatingQRButton() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showQRScanner,
          borderRadius: BorderRadius.circular(35),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
