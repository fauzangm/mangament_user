import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangament_acara/core/themes/AppColors.dart';
import '../bloc/undangan/undangan_bloc.dart';
import '../models/undangan.dart';
import 'presensi_page.dart';
import 'detail_acara.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  void _showQRScanner() async {
    final result = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (context) => const PresensiPage()));

    // ⬇️ JIKA PRESENSI / CHECKIN BERHASIL
    if (result == true) {
      context.read<UndanganBloc>().add(LoadUndangan());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<UndanganBloc>();
      if (bloc.state is UndanganInitial) {
        bloc.add(LoadUndangan());
      }
    });
  }

  void _toggleFilter(String status, String? currentSelected) {
    final bloc = context.read<UndanganBloc>();
    final next = currentSelected == status ? null : status;
    bloc.add(FilterUndangan(status: next));
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
            'description':
                undangan.description ??
                'Join us for this amazing event where we will discuss the latest trends in digital transformation and network with industry experts.',
            'status': undangan.status,
            'lat': -6.2088,
            'lng': 106.8456,
          },
          acaraId: int.parse(undangan.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
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
                          return _buildInvitationContent(
                            allUndangans: state.allUndangans,
                            visibleUndangans: state.visibleUndangans,
                            selectedStatus: state.selectedStatus,
                          );
                        }

                        return const Center(child: Text('No invitations'));
                      },
                    ),
                    // Header di atas
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: BlocBuilder<UndanganBloc, UndanganState>(
                        builder: (context, state) {
                          int total = 0;
                          int pending = 0;
                          int confirmed = 0;
                          int declined = 0;
                          String? selectedStatus;

                          if (state is UndanganLoaded) {
                            total = state.totalCount;
                            pending = state.pendingCount;
                            confirmed = state.confirmedCount;
                            declined = state.declinedCount;
                            selectedStatus = state.selectedStatus;
                          }

                          return _buildTopHeader(
                            total: total,
                            pending: pending,
                            confirmed: confirmed,
                            declined: declined,
                            selectedStatus: selectedStatus,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingQRButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTopHeader({
    required int total,
    required int pending,
    required int confirmed,
    required int declined,
    required String? selectedStatus,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 28),
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Invitations',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$total invitations',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.logout, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildFilterCard(
                  statusKey: 'pending',
                  title: 'Pending',
                  count: pending,
                  selectedStatus: selectedStatus,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterCard(
                  statusKey: 'confirmed',
                  title: 'Confirmed',
                  count: confirmed,
                  selectedStatus: selectedStatus,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterCard(
                  statusKey: 'declined',
                  title: 'Declined',
                  count: declined,
                  selectedStatus: selectedStatus,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvitationContent({
    required List<Undangan> allUndangans,
    required List<Undangan> visibleUndangans,
    required String? selectedStatus,
  }) {
    final source = selectedStatus == null ? allUndangans : visibleUndangans;

    final pendingUndangans = source
        .where((u) => u.status.toLowerCase() == 'pending')
        .toList();
    final confirmedUndangans = source
        .where((u) => u.status.toLowerCase() == 'confirmed')
        .toList();
    final declinedUndangans = source
        .where((u) => u.status.toLowerCase() == 'declined')
        .toList();

    final selected = selectedStatus;
    final isFiltered = selected != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 210),
                    if (!isFiltered) ...[
                      if (pendingUndangans.isNotEmpty) ...[
                        _buildSectionHeader(
                          'REQUIRES ACTION (${pendingUndangans.length})',
                        ),
                        const SizedBox(height: 12),
                        ...pendingUndangans
                            .map((undangan) => _buildUndanganCard(undangan))
                            .toList(),
                        const SizedBox(height: 24),
                      ],
                      if (confirmedUndangans.isNotEmpty) ...[
                        _buildSectionHeader(
                          'CONFIRMED (${confirmedUndangans.length})',
                        ),
                        const SizedBox(height: 12),
                        ...confirmedUndangans
                            .map((undangan) => _buildUndanganCard(undangan))
                            .toList(),
                        const SizedBox(height: 24),
                      ],
                      if (declinedUndangans.isNotEmpty) ...[
                        _buildSectionHeader(
                          'DECLINED (${declinedUndangans.length})',
                        ),
                        const SizedBox(height: 12),
                        ...declinedUndangans
                            .map((undangan) => _buildUndanganCard(undangan))
                            .toList(),
                      ],
                    ] else ...[
                      if (selected == 'pending') ...[
                        _buildSectionHeader(
                          'REQUIRES ACTION (${pendingUndangans.length})',
                        ),
                        const SizedBox(height: 12),
                        ...pendingUndangans
                            .map((undangan) => _buildUndanganCard(undangan))
                            .toList(),
                      ] else if (selected == 'confirmed') ...[
                        _buildSectionHeader(
                          'CONFIRMED (${confirmedUndangans.length})',
                        ),
                        const SizedBox(height: 12),
                        ...confirmedUndangans
                            .map((undangan) => _buildUndanganCard(undangan))
                            .toList(),
                      ] else if (selected == 'declined') ...[
                        _buildSectionHeader(
                          'DECLINED (${declinedUndangans.length})',
                        ),
                        const SizedBox(height: 12),
                        ...declinedUndangans
                            .map((undangan) => _buildUndanganCard(undangan))
                            .toList(),
                      ],
                      if (selected == 'pending' && pendingUndangans.isEmpty)
                        _buildEmptyFilteredState(),
                      if (selected == 'confirmed' && confirmedUndangans.isEmpty)
                        _buildEmptyFilteredState(),
                      if (selected == 'declined' && declinedUndangans.isEmpty)
                        _buildEmptyFilteredState(),
                    ],
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterCard({
    required String statusKey,
    required String title,
    required int count,
    required String? selectedStatus,
  }) {
    final isSelected = selectedStatus == statusKey;

    return GestureDetector(
      onTap: () => _toggleFilter(statusKey, selectedStatus),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.18),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isSelected ? AppColors.primary : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildEmptyFilteredState() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: const Text(
          'No invitations for this status.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
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
    switch (status.toLowerCase()) {
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
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showQRScanner,
          borderRadius: BorderRadius.circular(35),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }
}
