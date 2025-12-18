import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DashboardProfileTab extends StatelessWidget {
  const DashboardProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.orange,
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text('John Doe', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'john.doe@example.com',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          Card(
            color: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.settings, color: AppColors.textPrimary),
              title: const Text(
                'Settings',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppColors.textPrimary),
              title: const Text(
                'Logout',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
