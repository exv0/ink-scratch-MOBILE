import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ink_scratch/features/auth/presentation/view_model/auth_viewmodel_provider.dart';
import 'package:ink_scratch/features/dashboard/presentation/pages/edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display Profile Image with fallback
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  user?.profilePicture != null &&
                      user!.profilePicture!.isNotEmpty
                  ? NetworkImage('http://localhost:3000/${user.profilePicture}')
                  : null,
              child:
                  user?.profilePicture == null || user!.profilePicture!.isEmpty
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 16),
            // Display Full Name
            Text(
              user?.fullName ?? user?.username ?? 'Guest User',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            // Display Email
            Text(
              user?.email ?? 'guest@inkscratch.com',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            // Display Bio if available
            if (user?.bio != null && user!.bio!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  user.bio!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 32),
            // Button to Edit Profile
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
