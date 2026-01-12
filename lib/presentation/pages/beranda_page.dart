import 'package:flutter/material.dart';
import 'package:mangament_acara/core/themes/AppColors.dart';
import '../widgets/neumorphic_button.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  static const List<_TabItem> _tabs = [
    _TabItem('Beranda', Icons.admin_panel_settings),
    _TabItem('Presensi', Icons.camera),
    _TabItem('Monitor', Icons.monitor),
    _TabItem('Profile', Icons.person),
  ];

  void _onSelect(int i) => setState(() => _currentIndex = i);

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
              const SizedBox(height: 24),
              // Header / title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowDark,
                            offset: Offset(6, 6),
                            blurRadius: 18,
                          ),
                          BoxShadow(
                            color: AppColors.shadowLight,
                            offset: Offset(-6, -6),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.event, color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Beranda',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildContentCard(_currentIndex),
                ),
              ),
              // Bottom navigation (neumorphic glossy)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowDark,
                        offset: Offset(10, 10),
                        blurRadius: 24,
                      ),
                      BoxShadow(
                        color: AppColors.shadowLight,
                        offset: Offset(-10, -10),
                        blurRadius: 24,
                      ),
                    ],
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primaryLighter, AppColors.primaryLight],
                    ),
                  ),
                  child: Row(
                    children: List.generate(_tabs.length, (i) {
                      final selected = i == _currentIndex;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: NeumorphicButton(
                            height: 56,
                            onPressed: () => _onSelect(i),
                            backgroundColor: selected ? AppColors.primary : AppColors.primaryLight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _tabs[i].icon,
                                    size: 20,
                                    color: selected ? Colors.white : AppColors.textPrimary,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _tabs[i].label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: selected ? Colors.white : AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(int index) {
    // glossy neumorphic card with placeholder content per tab
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppColors.cardGradient,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowDark,
            offset: Offset(12, 12),
            blurRadius: 30,
          ),
          BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(-12, -12),
            blurRadius: 30,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // glossy header badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppColors.glossyGradient,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x80FFFFFF)),
            ),
            child: Text(
              _tabs[index].label.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _tabs[index].icon,
                    size: 84,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Halaman ${_tabs[index].label}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Konten ringkas untuk modul ini akan muncul di sini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  const _TabItem(this.label, this.icon);
}