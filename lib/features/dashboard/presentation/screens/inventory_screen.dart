import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class InventoryItem {
  final String id;
  final String name;
  final String category;
  final int stock;
  final int minStock;
  final double price;
  final String sku;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.minStock,
    required this.price,
    required this.sku,
  });

  String get stockStatus {
    if (stock == 0) return 'Out of Stock';
    if (stock <= minStock) return 'Low Stock';
    return 'In Stock';
  }
}

final _items = [
  InventoryItem(
    id: '1',
    name: 'MacBook Pro M3',
    category: 'Laptops',
    stock: 24,
    minStock: 10,
    price: 1999,
    sku: 'APP-MBP-M3',
  ),
  InventoryItem(
    id: '2',
    name: 'iPhone 15 Pro',
    category: 'Phones',
    stock: 8,
    minStock: 15,
    price: 1199,
    sku: 'APP-IP15P',
  ),
  InventoryItem(
    id: '3',
    name: 'AirPods Pro',
    category: 'Audio',
    stock: 0,
    minStock: 20,
    price: 249,
    sku: 'APP-ADP-2',
  ),
  InventoryItem(
    id: '4',
    name: 'iPad Air',
    category: 'Tablets',
    stock: 41,
    minStock: 10,
    price: 599,
    sku: 'APP-IPA-5',
  ),
  InventoryItem(
    id: '5',
    name: 'Apple Watch S9',
    category: 'Wearables',
    stock: 5,
    minStock: 8,
    price: 399,
    sku: 'APP-AW-S9',
  ),
  InventoryItem(
    id: '6',
    name: 'Samsung S24 Ultra',
    category: 'Phones',
    stock: 19,
    minStock: 10,
    price: 1299,
    sku: 'SAM-S24U',
  ),
  InventoryItem(
    id: '7',
    name: 'Sony WH-1000XM5',
    category: 'Audio',
    stock: 33,
    minStock: 10,
    price: 349,
    sku: 'SON-WH5',
  ),
  InventoryItem(
    id: '8',
    name: 'Dell XPS 15',
    category: 'Laptops',
    stock: 7,
    minStock: 8,
    price: 1599,
    sku: 'DEL-XPS15',
  ),
  InventoryItem(
    id: '9',
    name: 'LG 4K Monitor',
    category: 'Monitors',
    stock: 12,
    minStock: 5,
    price: 699,
    sku: 'LG-4K-27',
  ),
  InventoryItem(
    id: '10',
    name: 'Logitech MX Keys',
    category: 'Accessories',
    stock: 0,
    minStock: 10,
    price: 119,
    sku: 'LOG-MXK',
  ),
];

const _categories = [
  'All',
  'Laptops',
  'Phones',
  'Audio',
  'Tablets',
  'Wearables',
  'Monitors',
  'Accessories',
];

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _category = 'All';
  String _search = '';

  List<InventoryItem> get _filtered => _items.where((item) {
    final matchCat = _category == 'All' || item.category == _category;
    final matchSearch =
        _search.isEmpty ||
        item.name.toLowerCase().contains(_search) ||
        item.sku.toLowerCase().contains(_search);
    return matchCat && matchSearch;
  }).toList();

  Color _stockColor(String s) => switch (s) {
    'In Stock' => AppColors.success,
    'Low Stock' => AppColors.warning,
    _ => AppColors.danger,
  };

  Color _stockBg(String s) => switch (s) {
    'In Stock' => AppColors.successSoft,
    'Low Stock' => AppColors.warningSoft,
    _ => AppColors.dangerSoft,
  };

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    final outOfStock = _items.where((i) => i.stock == 0).length;
    final lowStock = _items
        .where((i) => i.stock > 0 && i.stock <= i.minStock)
        .length;

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
                    'Inventory',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Track stock levels and products',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              _Btn(icon: Icons.upload_rounded, label: 'Import'),
              const SizedBox(width: 10),
              _Btn(icon: Icons.add, label: 'Add Product', filled: true),
            ],
          ),
          const SizedBox(height: 20),

          // Alert banner لو في out of stock
          if (outOfStock > 0)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.dangerSoft,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.danger.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.danger,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$outOfStock product(s) are out of stock · $lowStock running low',
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Review →',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Stats
          Row(
            children: [
              _StatCard(
                label: 'Total Products',
                value: '${_items.length}',
                icon: Icons.inventory_2_rounded,
                color: AppColors.accent,
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: 'In Stock',
                value:
                    '${_items.where((i) => i.stockStatus == 'In Stock').length}',
                icon: Icons.check_circle_rounded,
                color: AppColors.success,
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: 'Low Stock',
                value: '$lowStock',
                icon: Icons.warning_rounded,
                color: AppColors.warning,
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: 'Out of Stock',
                value: '$outOfStock',
                icon: Icons.remove_circle_rounded,
                color: AppColors.danger,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search + category filter
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
                      hintText: 'Search by name or SKU...',
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((c) {
                      final selected = _category == c;
                      return GestureDetector(
                        onTap: () => setState(() => _category = c),
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
                            c,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    children: const [
                      Expanded(flex: 3, child: _TH('PRODUCT')),
                      Expanded(flex: 2, child: _TH('SKU')),
                      Expanded(flex: 2, child: _TH('CATEGORY')),
                      Expanded(flex: 2, child: _TH('PRICE')),
                      Expanded(flex: 2, child: _TH('STOCK')),
                      Expanded(flex: 2, child: _TH('STATUS')),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),
                items.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            'No products found',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: AppColors.border, height: 1),
                        itemBuilder: (_, i) {
                          final item = items[i];
                          return _InventoryRow(
                            item: item,
                            statusColor: _stockColor(item.stockStatus),
                            statusBg: _stockBg(item.stockStatus),
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

class _InventoryRow extends StatefulWidget {
  final InventoryItem item;
  final Color statusColor;
  final Color statusBg;
  const _InventoryRow({
    required this.item,
    required this.statusColor,
    required this.statusBg,
  });

  @override
  State<_InventoryRow> createState() => _InventoryRowState();
}

class _InventoryRowState extends State<_InventoryRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final maxStock = 50;
    final ratio = (widget.item.stock / maxStock).clamp(0.0, 1.0);

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
                widget.item.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.item.sku,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.item.category,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '\$${widget.item.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.item.stock} units',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Stack(
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: ratio,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: widget.statusColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
                  widget.item.stockStatus,
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
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
                  fontSize: 11,
                ),
              ),
            ],
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
