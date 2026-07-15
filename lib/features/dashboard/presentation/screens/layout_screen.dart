import 'package:dashboard_app/features/dashboard/presentation/screens/reports_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/dashboard_sidebar.dart';
import 'customers_screen.dart';
import 'dashboard_screen.dart';
import 'finance_screen.dart';
import 'inventory_screen.dart';
import 'orders_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int selectedItem = 0;

  final List<Widget> screens = const [
    DashboardScreen(),
    OrdersScreen(),
    InventoryScreen(),
    CustomersScreen(),
    ReportsScreen(),
    FinanceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          if (isWide)
            DashboardSidebar(
              selectedItem: selectedItem,
              onChanged: (index) {
                setState(() {
                  selectedItem = index;
                });
              },
            ),

          Expanded(child: screens[selectedItem]),
        ],
      ),
    );
  }
}
