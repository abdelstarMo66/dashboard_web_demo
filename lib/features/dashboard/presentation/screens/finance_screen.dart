import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class Invoice {
  final String id;
  final String client;
  final double amount;
  final String status;
  final String due;
  final String issued;

  const Invoice({
    required this.id,
    required this.client,
    required this.amount,
    required this.status,
    required this.due,
    required this.issued,
  });
}

final _invoices = [
  Invoice(
    id: 'INV-2025-001',
    client: 'Ahmed Hassan',
    amount: 12400,
    status: 'Paid',
    due: 'Jul 10',
    issued: 'Jun 25',
  ),
  Invoice(
    id: 'INV-2025-002',
    client: 'Nour Ali',
    amount: 31500,
    status: 'Paid',
    due: 'Jul 12',
    issued: 'Jun 27',
  ),
  Invoice(
    id: 'INV-2025-003',
    client: 'Sara Mahmoud',
    amount: 6200,
    status: 'Overdue',
    due: 'Jul 1',
    issued: 'Jun 15',
  ),
  Invoice(
    id: 'INV-2025-004',
    client: 'Karim Nasser',
    amount: 22000,
    status: 'Pending',
    due: 'Jul 20',
    issued: 'Jul 5',
  ),
  Invoice(
    id: 'INV-2025-005',
    client: 'Mona Ibrahim',
    amount: 9800,
    status: 'Paid',
    due: 'Jul 15',
    issued: 'Jul 1',
  ),
  Invoice(
    id: 'INV-2025-006',
    client: 'Omar Khalil',
    amount: 1800,
    status: 'Pending',
    due: 'Jul 25',
    issued: 'Jul 10',
  ),
  Invoice(
    id: 'INV-2025-007',
    client: 'Layla Samir',
    amount: 5100,
    status: 'Overdue',
    due: 'Jul 5',
    issued: 'Jun 20',
  ),
  Invoice(
    id: 'INV-2025-008',
    client: 'Tarek Fouad',
    amount: 15300,
    status: 'Pending',
    due: 'Jul 28',
    issued: 'Jul 13',
  ),
];

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _filter = 'All';
  final _filters = ['All', 'Paid', 'Pending', 'Overdue'];

  List<Invoice> get _filtered => _invoices
      .where((inv) => _filter == 'All' || inv.status == _filter)
      .toList();

  Color _statusColor(String s) => switch (s) {
    'Paid' => AppColors.success,
    'Pending' => AppColors.warning,
    _ => AppColors.danger,
  };

  Color _statusBg(String s) => switch (s) {
    'Paid' => AppColors.successSoft,
    'Pending' => AppColors.warningSoft,
    _ => AppColors.dangerSoft,
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final paid = _invoices
        .where((i) => i.status == 'Paid')
        .fold(0.0, (s, i) => s + i.amount);
    final pending = _invoices
        .where((i) => i.status == 'Pending')
        .fold(0.0, (s, i) => s + i.amount);
    final overdue = _invoices
        .where((i) => i.status == 'Overdue')
        .fold(0.0, (s, i) => s + i.amount);
    final total = paid + pending + overdue;

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
                    'Finance',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Invoices, payments and cash flow',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              _Btn(
                icon: Icons.receipt_long_rounded,
                label: 'New Invoice',
                filled: true,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Summary + Cash flow
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _FinanceSummary(
                        paid: paid,
                        pending: pending,
                        overdue: overdue,
                        total: total,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 3,
                      child: _CashFlowChart(controller: _controller),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _FinanceSummary(
                      paid: paid,
                      pending: pending,
                      overdue: overdue,
                      total: total,
                    ),
                    const SizedBox(height: 14),
                    _CashFlowChart(controller: _controller),
                  ],
                ),
          const SizedBox(height: 20),

          // Invoices Table
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
                    children: [
                      const Text(
                        'Invoices',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Filter tabs
                      ..._filters.map((f) {
                        final sel = _filter == f;
                        return GestureDetector(
                          onTap: () => setState(() => _filter = f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.accentSoft
                                  : AppColors.surfaceHigh,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel
                                    ? AppColors.accent
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              f,
                              style: TextStyle(
                                color: sel
                                    ? AppColors.accent
                                    : AppColors.textMuted,
                                fontSize: 11,
                                fontWeight: sel
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    children: const [
                      Expanded(flex: 3, child: _TH('INVOICE')),
                      Expanded(flex: 3, child: _TH('CLIENT')),
                      Expanded(flex: 2, child: _TH('ISSUED')),
                      Expanded(flex: 2, child: _TH('DUE DATE')),
                      Expanded(flex: 2, child: _TH('AMOUNT')),
                      Expanded(flex: 2, child: _TH('STATUS')),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: AppColors.border, height: 1),
                  itemBuilder: (_, i) {
                    final inv = _filtered[i];
                    return _InvoiceRow(
                      invoice: inv,
                      statusColor: _statusColor(inv.status),
                      statusBg: _statusBg(inv.status),
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

class _FinanceSummary extends StatelessWidget {
  final double paid, pending, overdue, total;
  const _FinanceSummary({
    required this.paid,
    required this.pending,
    required this.overdue,
    required this.total,
  });

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
          const Text(
            'Summary',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          _SummaryRow(
            label: 'Total Invoiced',
            value: '\$${(total / 1000).toStringAsFixed(1)}K',
            color: AppColors.textPrimary,
          ),
          const Divider(color: AppColors.border, height: 20),
          _SummaryRow(
            label: 'Collected',
            value: '\$${(paid / 1000).toStringAsFixed(1)}K',
            color: AppColors.success,
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Pending',
            value: '\$${(pending / 1000).toStringAsFixed(1)}K',
            color: AppColors.warning,
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Overdue',
            value: '\$${(overdue / 1000).toStringAsFixed(1)}K',
            color: AppColors.danger,
          ),
          const SizedBox(height: 20),
          // Progress bar
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: paid / total,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${(paid / total * 100).toStringAsFixed(0)}% collected',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        label,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      ),
      const Spacer(),
      Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _CashFlowChart extends StatefulWidget {
  final AnimationController controller;
  const _CashFlowChart({required this.controller});

  @override
  State<_CashFlowChart> createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<_CashFlowChart> {
  int? _hovered;
  final _income = [
    38000.0,
    52000.0,
    47000.0,
    65000.0,
    71000.0,
    83000.0,
    76000.0,
  ];
  final _expenses = [
    28000.0,
    34000.0,
    31000.0,
    42000.0,
    48000.0,
    56000.0,
    51000.0,
  ];
  final _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];

  @override
  Widget build(BuildContext context) {
    final max = _income.reduce((a, b) => a > b ? a : b);

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
              const Text(
                'Cash Flow',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _Legend(color: AppColors.success, label: 'Income'),
              const SizedBox(width: 16),
              _Legend(color: AppColors.danger, label: 'Expenses'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: AnimatedBuilder(
              animation: widget.controller,
              builder: (_, __) => Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(_months.length, (i) {
                  final incH =
                      (_income[i] / max) * 130 * widget.controller.value;
                  final expH =
                      (_expenses[i] / max) * 130 * widget.controller.value;
                  final isHov = _hovered == i;

                  return Expanded(
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _hovered = i),
                      onExit: (_) => setState(() => _hovered = null),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Income bar
                              Container(
                                width: 10,
                                height: incH,
                                decoration: BoxDecoration(
                                  color: isHov
                                      ? AppColors.success
                                      : AppColors.success.withOpacity(0.6),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(3),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 3),
                              // Expense bar
                              Container(
                                width: 10,
                                height: expH,
                                decoration: BoxDecoration(
                                  color: isHov
                                      ? AppColors.danger
                                      : AppColors.danger.withOpacity(0.5),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _months[i],
                            style: TextStyle(
                              color: isHov
                                  ? AppColors.textPrimary
                                  : AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
    ],
  );
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

class _InvoiceRow extends StatefulWidget {
  final Invoice invoice;
  final Color statusColor, statusBg;
  const _InvoiceRow({
    required this.invoice,
    required this.statusColor,
    required this.statusBg,
  });

  @override
  State<_InvoiceRow> createState() => _InvoiceRowState();
}

class _InvoiceRowState extends State<_InvoiceRow> {
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
              flex: 3,
              child: Text(
                widget.invoice.id,
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
                widget.invoice.client,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.invoice.issued,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.invoice.due,
                style: TextStyle(
                  color: widget.invoice.status == 'Overdue'
                      ? AppColors.danger
                      : AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: widget.invoice.status == 'Overdue'
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '\$${widget.invoice.amount.toStringAsFixed(0)}',
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
                  widget.invoice.status,
                  style: TextStyle(
                    color: widget.statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
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
