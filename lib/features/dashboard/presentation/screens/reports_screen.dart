import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _period = 'This Month';

  final _periods = ['This Week', 'This Month', 'This Quarter', 'This Year'];

  final _monthlyRevenue = [
    42000.0,
    58000.0,
    51000.0,
    73000.0,
    68000.0,
    91000.0,
    84500.0,
    96000.0,
    88000.0,
    102000.0,
    95000.0,
    112000.0,
  ];
  final _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final _categoryRevenue = [
    {'label': 'Laptops', 'value': 0.38, 'color': AppColors.accent},
    {'label': 'Phones', 'value': 0.28, 'color': AppColors.success},
    {'label': 'Audio', 'value': 0.14, 'color': const Color(0xFF06B6D4)},
    {'label': 'Tablets', 'value': 0.11, 'color': AppColors.warning},
    {'label': 'Others', 'value': 0.09, 'color': AppColors.danger},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
                    'Reports',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Analytics and performance insights',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              // Period selector
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: _periods.map((p) {
                    final sel = _period == p;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _period = p;
                        _controller.forward(from: 0);
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: sel ? AppColors.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          p,
                          style: TextStyle(
                            color: sel ? Colors.white : AppColors.textMuted,
                            fontSize: 12,
                            fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // KPI row
          Row(
            children: [
              _KpiTile(
                label: 'Total Revenue',
                value: '\$860.5K',
                change: '+18.2%',
                positive: true,
              ),
              const SizedBox(width: 12),
              _KpiTile(
                label: 'Gross Profit',
                value: '\$312.4K',
                change: '+12.1%',
                positive: true,
              ),
              const SizedBox(width: 12),
              _KpiTile(
                label: 'Expenses',
                value: '\$548.1K',
                change: '+5.3%',
                positive: false,
              ),
              const SizedBox(width: 12),
              _KpiTile(
                label: 'Net Margin',
                value: '36.3%',
                change: '+2.4%',
                positive: true,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Revenue chart (full width)
          _RevenueLineChart(
            months: _months,
            values: _monthlyRevenue,
            controller: _controller,
          ),
          const SizedBox(height: 14),

          // Category breakdown + Top months
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _CategoryBreakdown(
                        data: _categoryRevenue,
                        controller: _controller,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 3,
                      child: _TopMonthsChart(
                        months: _months,
                        values: _monthlyRevenue,
                        controller: _controller,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _CategoryBreakdown(
                      data: _categoryRevenue,
                      controller: _controller,
                    ),
                    const SizedBox(height: 14),
                    _TopMonthsChart(
                      months: _months,
                      values: _monthlyRevenue,
                      controller: _controller,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

// ── Revenue Line Chart ────────────────────────────────
class _RevenueLineChart extends StatelessWidget {
  final List<String> months;
  final List<double> values;
  final AnimationController controller;

  const _RevenueLineChart({
    required this.months,
    required this.values,
    required this.controller,
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
            'Annual Revenue',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Monthly breakdown for 2025',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                return CustomPaint(
                  size: const Size(double.infinity, 180),
                  painter: _LineChartPainter(
                    values: values,
                    progress: controller.value,
                    months: months,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: months
                .map(
                  (m) => Text(
                    m,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final double progress;
  final List<String> months;

  _LineChartPainter({
    required this.values,
    required this.progress,
    required this.months,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final min = values.reduce((a, b) => a < b ? a : b) * 0.8;
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = max - min;

    final points = List.generate(values.length, (i) {
      final x = i / (values.length - 1) * size.width;
      final y =
          size.height -
          ((values[i] - min) / range * size.height * 0.85 +
              size.height * 0.075);
      return Offset(x, y);
    });

    final visibleCount = (points.length * progress).ceil().clamp(
      1,
      points.length,
    );
    final vp = points.sublist(0, visibleCount);

    // Grid lines
    for (int g = 0; g <= 4; g++) {
      final y = size.height * g / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..color = AppColors.border
          ..strokeWidth = 0.5,
      );
    }

    // Fill
    final fp = Path()..moveTo(vp.first.dx, size.height);
    for (final p in vp) {
      fp.lineTo(p.dx, p.dy);
    }
    fp.lineTo(vp.last.dx, size.height);
    fp.close();
    canvas.drawPath(
      fp,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.accent.withOpacity(0.3),
            AppColors.accent.withOpacity(0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line
    final lp = Path()..moveTo(vp.first.dx, vp.first.dy);
    for (int i = 1; i < vp.length; i++) {
      final p0 = vp[i - 1], p1 = vp[i];
      final mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      lp.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    lp.lineTo(vp.last.dx, vp.last.dy);
    canvas.drawPath(
      lp,
      Paint()
        ..color = AppColors.accent
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Dots
    for (final p in vp) {
      canvas.drawCircle(p, 3, Paint()..color = AppColors.accent);
      canvas.drawCircle(p, 2, Paint()..color = AppColors.surface);
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter o) => o.progress != progress;
}

// ── Category Breakdown ────────────────────────────────
class _CategoryBreakdown extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final AnimationController controller;

  const _CategoryBreakdown({required this.data, required this.controller});

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
            'Revenue by Category',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          ...data.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item['label'] as String,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${((item['value'] as double) * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: item['color'] as Color,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  AnimatedBuilder(
                    animation: controller,
                    builder: (_, __) => Stack(
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor:
                              (item['value'] as double) * controller.value,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: item['color'] as Color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
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

// ── Top Months Chart ──────────────────────────────────
class _TopMonthsChart extends StatefulWidget {
  final List<String> months;
  final List<double> values;
  final AnimationController controller;
  const _TopMonthsChart({
    required this.months,
    required this.values,
    required this.controller,
  });

  @override
  State<_TopMonthsChart> createState() => _TopMonthsChartState();
}

class _TopMonthsChartState extends State<_TopMonthsChart> {
  int? _hovered;

  @override
  Widget build(BuildContext context) {
    final max = widget.values.reduce((a, b) => a > b ? a : b);

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
            'Monthly Comparison',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: AnimatedBuilder(
              animation: widget.controller,
              builder: (_, __) => Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(widget.values.length, (i) {
                  final ratio = widget.values[i] / max;
                  final barH = ratio * 130 * widget.controller.value;
                  final isHov = _hovered == i;
                  return Expanded(
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _hovered = i),
                      onExit: (_) => setState(() => _hovered = null),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isHov)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceHigh,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                '\$${(widget.values[i] / 1000).toStringAsFixed(0)}K',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              height: barH,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: isHov
                                      ? [
                                          AppColors.success,
                                          AppColors.success.withOpacity(0.5),
                                        ]
                                      : [
                                          AppColors.accent.withOpacity(0.7),
                                          AppColors.accent.withOpacity(0.2),
                                        ],
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.months[i],
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

class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final bool positive;
  const _KpiTile({
    required this.label,
    required this.value,
    required this.change,
    required this.positive,
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
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                positive ? Icons.arrow_upward : Icons.arrow_downward,
                size: 11,
                color: positive ? AppColors.success : AppColors.danger,
              ),
              const SizedBox(width: 3),
              Text(
                change,
                style: TextStyle(
                  color: positive ? AppColors.success : AppColors.danger,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
