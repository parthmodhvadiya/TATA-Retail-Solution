import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authService = Provider.of<AuthService>(
                context,
                listen: false,
              );
              await authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/signin');
              }
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _DashboardCard(
            title: 'Add New Product',
            icon: Icons.add_circle_outline,
            onTap: () => Navigator.pushNamed(context, '/add-product'),
          ),
          _DashboardCard(
            title: 'Create Invoice',
            icon: Icons.receipt_long,
            onTap: () => Navigator.pushNamed(context, '/create-invoice'),
          ),
          _DashboardCard(
            title: 'View Products',
            icon: Icons.inventory_2,
            onTap: () => Navigator.pushNamed(context, '/view-products'),
          ),
          _DashboardCard(
            title: 'View Invoices',
            icon: Icons.history,
            onTap: () => Navigator.pushNamed(context, '/view-invoices'),
          ),
          _DashboardCard(
            title: 'Sales Summary',
            icon: Icons.analytics,
            onTap: () => Navigator.pushNamed(context, '/sales-summary'),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
