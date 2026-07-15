import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int orders;
  final double totalSpent;
  final String since;
  final String tier;

  const CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.orders,
    required this.totalSpent,
    required this.since,
    required this.tier,
  });
}

final _customers = [
  CustomerModel(
    id: '1',
    name: 'Ahmed Hassan',
    email: 'ahmed@email.com',
    phone: '+20 100 123 4567',
    orders: 14,
    totalSpent: 12400,
    since: 'Jan 2023',
    tier: 'Gold',
  ),
  CustomerModel(
    id: '2',
    name: 'Sara Mahmoud',
    email: 'sara@email.com',
    phone: '+20 111 234 5678',
    orders: 8,
    totalSpent: 6200,
    since: 'Mar 2023',
    tier: 'Silver',
  ),
  CustomerModel(
    id: '3',
    name: 'Omar Khalil',
    email: 'omar@email.com',
    phone: '+20 122 345 6789',
    orders: 3,
    totalSpent: 1800,
    since: 'Jun 2024',
    tier: 'Bronze',
  ),
  CustomerModel(
    id: '4',
    name: 'Nour Ali',
    email: 'nour@email.com',
    phone: '+20 100 456 7890',
    orders: 22,
    totalSpent: 31500,
    since: 'Aug 2022',
    tier: 'Platinum',
  ),
  CustomerModel(
    id: '5',
    name: 'Youssef Adel',
    email: 'youssef@email.com',
    phone: '+20 111 567 8901',
    orders: 5,
    totalSpent: 3400,
    since: 'Nov 2023',
    tier: 'Bronze',
  ),
  CustomerModel(
    id: '6',
    name: 'Mona Ibrahim',
    email: 'mona@email.com',
    phone: '+20 122 678 9012',
    orders: 11,
    totalSpent: 9800,
    since: 'Feb 2023',
    tier: 'Silver',
  ),
  CustomerModel(
    id: '7',
    name: 'Karim Nasser',
    email: 'karim@email.com',
    phone: '+20 100 789 0123',
    orders: 19,
    totalSpent: 22000,
    since: 'May 2022',
    tier: 'Gold',
  ),
  CustomerModel(
    id: '8',
    name: 'Layla Samir',
    email: 'layla@email.com',
    phone: '+20 111 890 1234',
    orders: 7,
    totalSpent: 5100,
    since: 'Sep 2023',
    tier: 'Bronze',
  ),
];

const _tiers = ['All', 'Platinum', 'Gold', 'Silver', 'Bronze'];

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String _tier = 'All';
  String _search = '';

  List<CustomerModel> get _filtered => _customers.where((c) {
    final matchTier = _tier == 'All' || c.tier == _tier;
    final matchSearch =
        _search.isEmpty ||
        c.name.toLowerCase().contains(_search) ||
        c.email.toLowerCase().contains(_search);
    return matchTier && matchSearch;
  }).toList();

  Color _tierColor(String t) => switch (t) {
    'Platinum' => const Color(0xFF06B6D4),
    'Gold' => AppColors.warning,
    'Silver' => AppColors.textSecondary,
    _ => const Color(0xFFCD7F32),
  };

  @override
  Widget build(BuildContext context) {
    final customers = _filtered;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customers',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Manage your customer base',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              _Btn(
                icon: Icons.person_add_rounded,
                label: 'Add Customer',
                filled: true,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats
          Row(
            children: [
              _StatTile(
                label: 'Total Customers',
                value: '${_customers.length}',
                color: AppColors.accent,
              ),
              const SizedBox(width: 12),
              _StatTile(
                label: 'Platinum',
                value:
                    '${_customers.where((c) => c.tier == 'Platinum').length}',
                color: const Color(0xFF06B6D4),
              ),
              const SizedBox(width: 12),
              _StatTile(
                label: 'Gold',
                value: '${_customers.where((c) => c.tier == 'Gold').length}',
                color: AppColors.warning,
              ),
              const SizedBox(width: 12),
              _StatTile(
                label: 'Avg. Spent',
                value:
                    '\$${(_customers.fold(0.0, (s, c) => s + c.totalSpent) / _customers.length).toStringAsFixed(0)}',
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search + Tier filter
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v.toLowerCase()),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search by name or email...',
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
                const SizedBox(height: 12),
                Row(
                  children: _tiers.map((t) {
                    final selected = _tier == t;
                    return GestureDetector(
                      onTap: () => setState(() => _tier = t),
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
                          t,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    children: const [
                      Expanded(flex: 3, child: _TH('CUSTOMER')),
                      Expanded(flex: 3, child: _TH('EMAIL')),
                      Expanded(flex: 2, child: _TH('PHONE')),
                      Expanded(flex: 1, child: _TH('ORDERS')),
                      Expanded(flex: 2, child: _TH('TOTAL SPENT')),
                      Expanded(flex: 2, child: _TH('TIER')),
                      Expanded(flex: 2, child: _TH('SINCE')),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),
                customers.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            'No customers found',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: customers.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: AppColors.border, height: 1),
                        itemBuilder: (_, i) => _CustomerRow(
                          customer: customers[i],
                          tierColor: _tierColor(customers[i].tier),
                        ),
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

class _CustomerRow extends StatefulWidget {
  final CustomerModel customer;
  final Color tierColor;
  const _CustomerRow({required this.customer, required this.tierColor});

  @override
  State<_CustomerRow> createState() => _CustomerRowState();
}

class _CustomerRowState extends State<_CustomerRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _hovered ? AppColors.surfaceHigh : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.accentSoft,
                    child: Text(
                      widget.customer.name[0],
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.customer.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                widget.customer.email,
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
                widget.customer.phone,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${widget.customer.orders}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '\$${widget.customer.totalSpent.toStringAsFixed(0)}',
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
                  color: widget.tierColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.customer.tier,
                  style: TextStyle(
                    color: widget.tierColor,
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
                widget.customer.since,
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

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  const _Btn({required this.icon, required this.label, this.filled = false});

  @override
  Widget build(BuildContext context) => Container(
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
