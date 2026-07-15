import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class OrderModel {
  final String id;
  final String customer;
  final String product;
  final double amount;
  final String status;
  final String date;
  final int quantity;

  const OrderModel({
    required this.id,
    required this.customer,
    required this.product,
    required this.amount,
    required this.status,
    required this.date,
    required this.quantity,
  });
}

final _allOrders = [
  OrderModel(
    id: '#ORD-4821',
    customer: 'Ahmed Hassan',
    product: 'MacBook Pro M3',
    amount: 1999,
    status: 'Delivered',
    date: 'Jul 14, 2025',
    quantity: 1,
  ),
  OrderModel(
    id: '#ORD-4820',
    customer: 'Sara Mahmoud',
    product: 'iPhone 15 Pro',
    amount: 1199,
    status: 'Processing',
    date: 'Jul 14, 2025',
    quantity: 2,
  ),
  OrderModel(
    id: '#ORD-4819',
    customer: 'Omar Khalil',
    product: 'AirPods Pro',
    amount: 249,
    status: 'Shipped',
    date: 'Jul 13, 2025',
    quantity: 3,
  ),
  OrderModel(
    id: '#ORD-4818',
    customer: 'Nour Ali',
    product: 'iPad Air',
    amount: 599,
    status: 'Pending',
    date: 'Jul 13, 2025',
    quantity: 1,
  ),
  OrderModel(
    id: '#ORD-4817',
    customer: 'Youssef Adel',
    product: 'Apple Watch',
    amount: 399,
    status: 'Cancelled',
    date: 'Jul 12, 2025',
    quantity: 1,
  ),
  OrderModel(
    id: '#ORD-4816',
    customer: 'Mona Ibrahim',
    product: 'Samsung S24',
    amount: 899,
    status: 'Delivered',
    date: 'Jul 12, 2025',
    quantity: 2,
  ),
  OrderModel(
    id: '#ORD-4815',
    customer: 'Karim Nasser',
    product: 'Dell XPS 15',
    amount: 1599,
    status: 'Shipped',
    date: 'Jul 11, 2025',
    quantity: 1,
  ),
  OrderModel(
    id: '#ORD-4814',
    customer: 'Layla Samir',
    product: 'Sony WH-1000XM5',
    amount: 349,
    status: 'Delivered',
    date: 'Jul 11, 2025',
    quantity: 2,
  ),
  OrderModel(
    id: '#ORD-4813',
    customer: 'Tarek Fouad',
    product: 'LG 4K Monitor',
    amount: 699,
    status: 'Processing',
    date: 'Jul 10, 2025',
    quantity: 1,
  ),
  OrderModel(
    id: '#ORD-4812',
    customer: 'Rania Mostafa',
    product: 'Kindle Paperwhite',
    amount: 139,
    status: 'Delivered',
    date: 'Jul 10, 2025',
    quantity: 4,
  ),
  OrderModel(
    id: '#ORD-4811',
    customer: 'Hossam Fathy',
    product: 'GoPro Hero 12',
    amount: 399,
    status: 'Pending',
    date: 'Jul 9, 2025',
    quantity: 1,
  ),
  OrderModel(
    id: '#ORD-4810',
    customer: 'Dina Ramzy',
    product: 'iPhone 15 Pro',
    amount: 1199,
    status: 'Cancelled',
    date: 'Jul 9, 2025',
    quantity: 1,
  ),
];

const _statuses = [
  'All',
  'Delivered',
  'Processing',
  'Shipped',
  'Pending',
  'Cancelled',
];

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _selectedStatus = 'All';
  String _search = '';

  List<OrderModel> get _filtered => _allOrders.where((o) {
    final matchStatus = _selectedStatus == 'All' || o.status == _selectedStatus;
    final matchSearch =
        _search.isEmpty ||
        o.id.toLowerCase().contains(_search) ||
        o.customer.toLowerCase().contains(_search) ||
        o.product.toLowerCase().contains(_search);
    return matchStatus && matchSearch;
  }).toList();

  Color _statusColor(String s) => switch (s) {
    'Delivered' => AppColors.success,
    'Processing' => AppColors.accent,
    'Shipped' => const Color(0xFF06B6D4),
    'Pending' => AppColors.warning,
    'Cancelled' => AppColors.danger,
    _ => AppColors.textMuted,
  };

  Color _statusBg(String s) => switch (s) {
    'Delivered' => AppColors.successSoft,
    'Processing' => AppColors.accentSoft,
    'Shipped' => const Color(0x2206B6D4),
    'Pending' => AppColors.warningSoft,
    'Cancelled' => AppColors.dangerSoft,
    _ => AppColors.border,
  };

  @override
  Widget build(BuildContext context) {
    final orders = _filtered;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Orders',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Manage and track all orders',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              _ActionButton(icon: Icons.download_rounded, label: 'Export'),
              const SizedBox(width: 10),
              _ActionButton(icon: Icons.add, label: 'New Order', filled: true),
            ],
          ),
          const SizedBox(height: 20),

          // Summary cards
          Row(
            children: [
              _SummaryTile(
                label: 'Total Orders',
                value: '${_allOrders.length}',
                color: AppColors.accent,
              ),
              const SizedBox(width: 12),
              _SummaryTile(
                label: 'Delivered',
                value:
                    '${_allOrders.where((o) => o.status == 'Delivered').length}',
                color: AppColors.success,
              ),
              const SizedBox(width: 12),
              _SummaryTile(
                label: 'Pending',
                value:
                    '${_allOrders.where((o) => o.status == 'Pending').length}',
                color: AppColors.warning,
              ),
              const SizedBox(width: 12),
              _SummaryTile(
                label: 'Cancelled',
                value:
                    '${_allOrders.where((o) => o.status == 'Cancelled').length}',
                color: AppColors.danger,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search + Filter
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Search
                    Expanded(
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: TextField(
                          onChanged: (v) =>
                              setState(() => _search = v.toLowerCase()),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Search by ID, customer, product...',
                            hintStyle: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.textMuted,
                              size: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Status filter tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _statuses.map((s) {
                      final selected = _selectedStatus == s;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedStatus = s),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.accentSoft
                                : AppColors.surfaceHigh,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? AppColors.accent
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(
                              color: selected
                                  ? AppColors.accent
                                  : AppColors.textMuted,
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Table
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    children: const [
                      Expanded(flex: 2, child: _TH('ORDER ID')),
                      Expanded(flex: 3, child: _TH('CUSTOMER')),
                      Expanded(flex: 3, child: _TH('PRODUCT')),
                      Expanded(flex: 1, child: _TH('QTY')),
                      Expanded(flex: 2, child: _TH('AMOUNT')),
                      Expanded(flex: 2, child: _TH('STATUS')),
                      Expanded(flex: 2, child: _TH('DATE')),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),

                // Rows
                orders.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            'No orders found',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: AppColors.border, height: 1),
                        itemBuilder: (_, i) {
                          final o = orders[i];
                          return _OrderRow(
                            order: o,
                            statusColor: _statusColor(o.status),
                            statusBg: _statusBg(o.status),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TH extends StatelessWidget {
  final String text;
  const _TH(this.text);
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
  final OrderModel order;
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
        color: _hovered ? AppColors.surfaceHigh : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
              flex: 1,
              child: Text(
                '${widget.order.quantity}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
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
              flex: 2,
              child: Text(
                widget.order.date,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: Icon(
                Icons.more_horiz,
                color: _hovered ? AppColors.textSecondary : Colors.transparent,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  const _ActionButton({
    required this.icon,
    required this.label,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? AppColors.accent : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: filled ? AppColors.accent : AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: filled ? Colors.white : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: filled ? Colors.white : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
