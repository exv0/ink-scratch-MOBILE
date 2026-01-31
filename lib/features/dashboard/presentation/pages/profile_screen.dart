import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ink_scratch/core/config/app_config.dart'; // ✅ Import AppConfig
import 'package:ink_scratch/features/auth/presentation/view_model/auth_viewmodel_provider.dart';
import 'package:ink_scratch/features/dashboard/presentation/pages/edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.currentUser;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ✅ FIXED: Use the profilePicture directly - backend now returns full URL
    final ImageProvider? profileImageProvider =
        (user?.profilePicture != null && user!.profilePicture!.isNotEmpty)
        ? NetworkImage(user.profilePicture!) // ✅ Just use the URL directly
        : null;

    // Accent color used throughout
    const Color accent = Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F5F7),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Gradient Header with Avatar ───
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            stretch: true,
            backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            flexibleSpace: FlexibleSpaceBackground(
              isDark: isDark,
              child: FlexibleSpaceHeader(
                profileImageProvider: profileImageProvider,
                isDark: isDark,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white70,
                    size: 22,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          // ─── Name, Username, Stats, Bio, Edit Button ───
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Name + @username
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullName ?? user?.username ?? 'Guest User',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@${user?.username ?? 'guest'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white38 : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _StatBadge(label: 'Posts', value: '0', isDark: isDark),
                    const SizedBox(width: 16),
                    _StatBadge(label: 'Followers', value: '0', isDark: isDark),
                    const SizedBox(width: 16),
                    _StatBadge(label: 'Following', value: '0', isDark: isDark),
                  ],
                ),

                const SizedBox(height: 16),

                // Bio
                if (user?.bio != null && user!.bio!.isNotEmpty) ...[
                  Text(
                    user.bio!,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Edit Profile button
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark
                            ? Colors.white24
                            : accent.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      foregroundColor: accent,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),

          // ─── Divider ───
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Divider(
                  color: isDark ? Colors.white10 : Colors.grey[200],
                  height: 1,
                ),
              ]),
            ),
          ),

          // ─── Personal Details Section ───
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionLabel(title: 'PERSONAL DETAILS', isDark: isDark),
                const SizedBox(height: 10),
                _DetailCard(
                  isDark: isDark,
                  children: [
                    _DetailRow(
                      icon: Icons.person_outline,
                      label: 'Full Name',
                      value: user?.fullName ?? 'Not set',
                      isDark: isDark,
                    ),
                    _divider(isDark),
                    _DetailRow(
                      icon: Icons.badge_outlined,
                      label: 'Username',
                      value: user?.username ?? 'Not set',
                      isDark: isDark,
                    ),
                    _divider(isDark),
                    _DetailRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user?.email ?? 'Not set',
                      isDark: isDark,
                    ),
                    _divider(isDark),
                    _DetailRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value:
                          user?.phoneNumber != null &&
                              user!.phoneNumber!.toString().isNotEmpty
                          ? user.phoneNumber!.toString()
                          : 'Not set',
                      isDark: isDark,
                    ),
                    _divider(isDark),
                    _DetailRow(
                      icon: Icons.wc_outlined,
                      label: 'Gender',
                      value: user?.gender != null && user!.gender!.isNotEmpty
                          ? _capitalize(user.gender!)
                          : 'Not set',
                      isDark: isDark,
                    ),
                    _divider(isDark),
                    _DetailRow(
                      icon: Icons.shield_outlined,
                      label: 'Role',
                      value: user?.role != null && user!.role!.isNotEmpty
                          ? _capitalize(user.role!)
                          : 'User',
                      isDark: isDark,
                      isLast: true,
                    ),
                  ],
                ),
              ]),
            ),
          ),

          // ─── Settings Section ───
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionLabel(title: 'SETTINGS', isDark: isDark),
                const SizedBox(height: 10),
                _DetailCard(
                  isDark: isDark,
                  children: [
                    _SettingsRow(
                      icon: Icons.lock_outlined,
                      label: 'Privacy & Security',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _divider(isDark),
                    _SettingsRow(
                      icon: Icons.notifications_none_outlined,
                      label: 'Notifications',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _divider(isDark),
                    _SettingsRow(
                      icon: Icons.language_outlined,
                      label: 'Language',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _divider(isDark),
                    _SettingsRow(
                      icon: Icons.dark_mode_outlined,
                      label: 'Appearance',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _divider(isDark),
                    _SettingsRow(
                      icon: Icons.help_outline,
                      label: 'Help & Support',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _divider(isDark),
                    _SettingsRow(
                      icon: Icons.info_outline,
                      label: 'About',
                      isDark: isDark,
                      onTap: () {},
                      isLast: true,
                    ),
                  ],
                ),
              ]),
            ),
          ),

          // ─── Logout Button ───
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? Colors.red.shade900.withValues(alpha: 0.3)
                          : Colors.red.shade50,
                      foregroundColor: Colors.red.shade500,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout_outlined, size: 20),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => _LogoutDialog(isDark: isDark),
                      );
                      if (confirmed == true && context.mounted) {
                        ref.read(authViewModelProvider.notifier).logout();
                      }
                    },
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  static Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? Colors.white.withValues(alpha: 0.07) : Colors.grey[100],
    );
  }
}

// ─── Gradient Background ────────────────────────────────────────────────────

class FlexibleSpaceBackground extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const FlexibleSpaceBackground({
    super.key,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
              : [const Color(0xFF6C63FF), const Color(0xFF4A90D9)],
        ),
      ),
      child: child,
    );
  }
}

// ─── Header Avatar inside the gradient ──────────────────────────────────────

class FlexibleSpaceHeader extends StatelessWidget {
  final ImageProvider? profileImageProvider;
  final bool isDark;

  const FlexibleSpaceHeader({
    super.key,
    required this.profileImageProvider,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 54,
            backgroundColor: isDark
                ? const Color(0xFF2C2C3E)
                : const Color(0xFFE0E0E0),
            backgroundImage: profileImageProvider,
            child: profileImageProvider == null
                ? const Icon(Icons.person, size: 44, color: Colors.white54)
                : null,
          ),
        ),
      ),
    );
  }
}

// ─── Stat Badge (Posts / Followers / Following) ─────────────────────────────

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Label (e.g. "PERSONAL DETAILS") ───────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionLabel({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white24 : Colors.grey[400],
        letterSpacing: 1.2,
      ),
    );
  }
}

// ─── Card wrapper for grouped rows ──────────────────────────────────────────

class _DetailCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _DetailCard({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(children: children),
    );
  }
}

// ─── Single detail row (icon + label + value) ───────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          // Icon bubble
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: Icon(icon, size: 17, color: Color(0xFF6C63FF)),
            ),
          ),
          const SizedBox(width: 14),
          // Label + Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
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

// ─── Settings row (icon + label + chevron) ──────────────────────────────────

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;
  final bool isLast;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(9),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 17,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: isDark ? Colors.white24 : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Logout Confirmation Dialog ─────────────────────────────────────────────

class _LogoutDialog extends StatelessWidget {
  final bool isDark;

  const _LogoutDialog({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Logout',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Are you sure you want to log out?',
        style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[600]),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[500]),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
