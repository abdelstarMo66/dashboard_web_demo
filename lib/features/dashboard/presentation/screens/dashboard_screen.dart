import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/dashboard_data.dart';
import '../widgets/kpi_card.dart';
import '../widgets/recent_orders_table.dart';
import '../widgets/revenue_chart.dart';
import '../widgets/top_products.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Column(
      children: [
        _TopBar(isWide: isWide),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page title
                const _PageHeader(),
                const SizedBox(height: 20),

                // KPI Cards
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 4 : 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: isWide ? 1.3 : 1.1,
                  ),
                  itemCount: mockKpis.length,
                  itemBuilder: (_, i) => KpiCard(data: mockKpis[i], index: i),
                ),
                const SizedBox(height: 20),

                // Revenue Chart + Top Products
                isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(flex: 3, child: RevenueChart()),
                          const SizedBox(width: 14),
                          const Expanded(flex: 2, child: TopProductsWidget()),
                        ],
                      )
                    : const Column(
                        children: [
                          RevenueChart(),
                          SizedBox(height: 14),
                          TopProductsWidget(),
                        ],
                      ),
                const SizedBox(height: 20),

                // Recent Orders
                const RecentOrdersTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Top Bar ────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final bool isWide;
  const _TopBar({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (!isWide) ...[
            const Icon(Icons.bolt, color: AppColors.accent),
            const SizedBox(width: 8),
            const Text(
              'NexusERP',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const Spacer(),
          ] else ...[
            // Search bar
            Container(
              width: 260,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 12),
                  Icon(Icons.search, color: AppColors.textMuted, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Search anything...',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],

          // Actions
          _IconBtn(Icons.notifications_none_rounded, badge: true),
          const SizedBox(width: 8),
          _IconBtn(Icons.settings_outlined),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.accentSoft,
            child: Text(
              'A',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatefulWidget {
  final IconData icon;
  final bool badge;
  const _IconBtn(this.icon, {this.badge = false});

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceHigh : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(widget.icon, color: AppColors.textSecondary, size: 18),
            if (widget.badge)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Page Header ────────────────────────────────────────
class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Wednesday, July 16 · 2025',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.add, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text(
                'New Order',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
