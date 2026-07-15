class KpiData {
  final String label;
  final double value;
  final String formatted;
  final double changePercent;
  final bool isPositive;
  final String icon;
  final List<double> sparkline;

  const KpiData({
    required this.label,
    required this.value,
    required this.formatted,
    required this.changePercent,
    required this.isPositive,
    required this.icon,
    required this.sparkline,
  });
}

class RecentOrder {
  final String id;
  final String customer;
  final String product;
  final double amount;
  final String status;
  final String date;

  const RecentOrder({
    required this.id,
    required this.customer,
    required this.product,
    required this.amount,
    required this.status,
    required this.date,
  });
}

class TopProduct {
  final String name;
  final int units;
  final double revenue;
  final double percentage;

  const TopProduct({
    required this.name,
    required this.units,
    required this.revenue,
    required this.percentage,
  });
}

// ── Mock Data ──────────────────────────────────────

final mockKpis = [
  KpiData(
    label: 'Total Revenue',
    value: 284500,
    formatted: '\$284.5K',
    changePercent: 12.4,
    isPositive: true,
    icon: '💰',
    sparkline: [120, 145, 130, 160, 175, 190, 210, 240, 228, 260, 272, 284],
  ),
  KpiData(
    label: 'Orders',
    value: 1842,
    formatted: '1,842',
    changePercent: 8.1,
    isPositive: true,
    icon: '📦',
    sparkline: [
      900,
      980,
      1050,
      1100,
      1200,
      1320,
      1400,
      1500,
      1600,
      1700,
      1780,
      1842,
    ],
  ),
  KpiData(
    label: 'Customers',
    value: 6391,
    formatted: '6,391',
    changePercent: 3.2,
    isPositive: true,
    icon: '👥',
    sparkline: [
      5800,
      5900,
      5950,
      6000,
      6100,
      6150,
      6200,
      6250,
      6300,
      6340,
      6370,
      6391,
    ],
  ),
  KpiData(
    label: 'Returns',
    value: 143,
    formatted: '143',
    changePercent: 2.7,
    isPositive: false,
    icon: '↩️',
    sparkline: [90, 100, 95, 110, 120, 115, 130, 125, 135, 138, 140, 143],
  ),
];

final mockOrders = [
  RecentOrder(
    id: '#ORD-4821',
    customer: 'Ahmed Hassan',
    product: 'MacBook Pro M3',
    amount: 1999,
    status: 'Delivered',
    date: 'Jul 14',
  ),
  RecentOrder(
    id: '#ORD-4820',
    customer: 'Sara Mahmoud',
    product: 'iPhone 15 Pro',
    amount: 1199,
    status: 'Processing',
    date: 'Jul 14',
  ),
  RecentOrder(
    id: '#ORD-4819',
    customer: 'Omar Khalil',
    product: 'AirPods Pro',
    amount: 249,
    status: 'Shipped',
    date: 'Jul 13',
  ),
  RecentOrder(
    id: '#ORD-4818',
    customer: 'Nour Ali',
    product: 'iPad Air',
    amount: 599,
    status: 'Pending',
    date: 'Jul 13',
  ),
  RecentOrder(
    id: '#ORD-4817',
    customer: 'Youssef Adel',
    product: 'Apple Watch',
    amount: 399,
    status: 'Cancelled',
    date: 'Jul 12',
  ),
  RecentOrder(
    id: '#ORD-4816',
    customer: 'Mona Ibrahim',
    product: 'Samsung S24',
    amount: 899,
    status: 'Delivered',
    date: 'Jul 12',
  ),
];

final mockTopProducts = [
  TopProduct(
    name: 'MacBook Pro M3',
    units: 312,
    revenue: 623688,
    percentage: 0.85,
  ),
  TopProduct(
    name: 'iPhone 15 Pro',
    units: 489,
    revenue: 586311,
    percentage: 0.72,
  ),
  TopProduct(
    name: 'Samsung S24',
    units: 401,
    revenue: 360499,
    percentage: 0.58,
  ),
  TopProduct(name: 'iPad Air', units: 278, revenue: 166722, percentage: 0.43),
  TopProduct(
    name: 'AirPods Pro',
    units: 634,
    revenue: 157866,
    percentage: 0.35,
  ),
];

final revenueChart = [
  {'month': 'Jan', 'value': 42000.0},
  {'month': 'Feb', 'value': 58000.0},
  {'month': 'Mar', 'value': 51000.0},
  {'month': 'Apr', 'value': 73000.0},
  {'month': 'May', 'value': 68000.0},
  {'month': 'Jun', 'value': 91000.0},
  {'month': 'Jul', 'value': 84500.0},
];
