import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ink_scratch/features/auth/presentation/view_model/auth_viewmodel_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const Color _accent = Color(0xFF6C63FF);

  final List<Map<String, dynamic>> continueReading = const [
    {"title": "One Piece", "chapter": 1124, "progress": 75},
    {"title": "Jujutsu Kaisen", "chapter": 261, "progress": 45},
    {"title": "Chainsaw Man", "chapter": 170, "progress": 90},
  ];

  final List<Map<String, dynamic>> myLibrary = const [
    {"title": "Berserk", "color": 0xFF8B0000},
    {"title": "Vinland Saga", "color": 0xFF1A5276},
    {"title": "Attack on Titan", "color": 0xFF922B21},
    {"title": "Demon Slayer", "color": 0xFF1F618D},
    {"title": "Solo Leveling", "color": 0xFF4A235A},
    {"title": "My Hero Academia", "color": 0xFF1E8449},
    {"title": "Tokyo Ghoul", "color": 0xFF212121},
    {"title": "Naruto", "color": 0xFFD35400},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = ref.watch(authViewModelProvider).currentUser;
    final String username = user?.username ?? 'User';

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F5F7),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Gradient Header ────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            stretch: true,
            backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                        : [_accent, const Color(0xFF4A90D9)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Good morning, $username 👋',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pick up where you left off',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () {},
              ),
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

          // ─── Body Content ───────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ─── Brand Label ──────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_accent, const Color(0xFF4A90D9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Ink Scratch',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.6)
                            : Colors.grey[500],
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ─── Continue Reading ─────────────────────────────────────
                _SectionHeader(
                  title: 'CONTINUE READING',
                  isDark: isDark,
                  hasAction: true,
                ),
                const SizedBox(height: 14),

                SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: continueReading.length,
                    itemBuilder: (context, index) {
                      final item = continueReading[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < continueReading.length - 1 ? 14 : 0,
                        ),
                        child: _ReadingCard(item: item, isDark: isDark),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 36),

                // ─── My Library ───────────────────────────────────────────
                _SectionHeader(
                  title: 'MY LIBRARY',
                  isDark: isDark,
                  hasAction: true,
                  actionIcon: Icons.add_circle_outline,
                ),
                const SizedBox(height: 14),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 18,
                  ),
                  itemCount: myLibrary.length,
                  itemBuilder: (context, index) {
                    final item = myLibrary[index];
                    return _LibraryTile(
                      title: item['title'],
                      color: Color(item['color']),
                      isDark: isDark,
                    );
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header (label + optional action) ───────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;
  final bool hasAction;
  final IconData actionIcon;

  const _SectionHeader({
    required this.title,
    required this.isDark,
    this.hasAction = false,
    this.actionIcon = Icons.chevron_right,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white24 : Colors.grey[400],
            letterSpacing: 1.2,
          ),
        ),
        if (hasAction)
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                children: [
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12,
                      color: HomeScreen._accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(actionIcon, size: 15, color: HomeScreen._accent),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Reading Card ────────────────────────────────────────────────────────────

class _ReadingCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isDark;

  const _ReadingCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final int progress = item['progress'];

    return SizedBox(
      width: 170,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
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
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Cover ──
                Stack(
                  children: [
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF1A1A2E),
                                  const Color(0xFF16213E),
                                ]
                              : [HomeScreen._accent, const Color(0xFF4A90D9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 52,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    // Progress badge
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$progress%',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // ── Info ──
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      // Chapter row
                      Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: HomeScreen._accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.menu_book_rounded,
                                size: 13,
                                color: HomeScreen._accent,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ch. ${item["chapter"]}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white38 : Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress / 100,
                          minHeight: 5,
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            HomeScreen._accent,
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
      ),
    );
  }
}

// ─── Library Tile ────────────────────────────────────────────────────────────

class _LibraryTile extends StatelessWidget {
  final String title;
  final Color color;
  final bool isDark;

  const _LibraryTile({
    required this.title,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: isDark ? 0.2 : 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.book_rounded,
                  size: 32,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
