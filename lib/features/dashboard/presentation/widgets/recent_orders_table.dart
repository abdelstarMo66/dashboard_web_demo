import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/dashboard_data.dart';

class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({super.key});

  Color _statusColor(String status) => switch (status) {
    'Delivered' => AppColors.success,
    'Processing' => AppColors.accent,
    'Shipped' => const Color(0xFF06B6D4),
    'Pending' => AppColors.warning,
    'Cancelled' => AppColors.danger,
    _ => AppColors.textMuted,
  };

  Color _statusBg(String status) => switch (status) {
    'Delivered' => AppColors.successSoft,
    'Processing' => AppColors.accentSoft,
    'Shipped' => const Color(0x2206B6D4),
    'Pending' => AppColors.warningSoft,
    'Cancelled' => AppColors.dangerSoft,
    _ => AppColors.border,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Orders',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Last 7 days',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View all',
                  style: TextStyle(color: AppColors.accent, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: const [
                Expanded(flex: 2, child: _HeaderCell('ORDER')),
                Expanded(flex: 3, child: _HeaderCell('CUSTOMER')),
                Expanded(flex: 3, child: _HeaderCell('PRODUCT')),
                Expanded(flex: 2, child: _HeaderCell('AMOUNT')),
                Expanded(flex: 2, child: _HeaderCell('STATUS')),
                Expanded(flex: 1, child: _HeaderCell('DATE')),
              ],
            ),
          ),

          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 8),

          // Rows
          ...mockOrders.map(
            (order) => _OrderRow(
              order: order,
              statusColor: _statusColor(order.status),
              statusBg: _statusBg(order.status),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: AppColors.textMuted,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
    ),
  );
}

class _OrderRow extends StatefulWidget {
  final RecentOrder order;
  final Color statusColor;
  final Color statusBg;

  const _OrderRow({
    required this.order,
    required this.statusColor,
    required this.statusBg,
  });

  @override
  State<_OrderRow> createState() => _OrderRowState();
}

class _OrderRowState extends State<_OrderRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceHigh : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                widget.order.id,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                widget.order.customer,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                widget.order.product,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '\$${widget.order.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.order.status,
                  style: TextStyle(
                    color: widget.statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                widget.order.date,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
