import 'package:flutter/material.dart';

class StaggeredMenuScreen extends StatefulWidget {
  const StaggeredMenuScreen({super.key});

  @override
  State<StaggeredMenuScreen> createState() => _StaggeredMenuScreenState();
}

class _StaggeredMenuScreenState extends State<StaggeredMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  static const _menuTitles = [
    'Home',
    'Profile',
    'Notifications',
    'Settings',
    'Logout',
  ];

  @override
  void initState() {
    super.initState();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_drawerSlideController.isCompleted) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  Widget _buildDrawerItem(int index, String title) {
    // Determine the interval for the animation
    // Each item starts a bit later than the previous one
    final double start = index * 0.1;
    final double end = start + 0.4;
    // ensure end doesn't exceed 1.0
    final double safeEnd = end > 1.0 ? 1.0 : end;

    final animation = CurvedAnimation(
      parent: _drawerSlideController,
      curve: Interval(start, safeEnd, curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(-200 * (1.0 - animation.value), 0),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: ListTile(
        leading: const Icon(Icons.circle, size: 12),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        onTap: () {
          // Handle tap
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staggered Animations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _drawerSlideController,
          ),
          onPressed: _toggleMenu,
        ),
      ),
      body: Stack(
        children: [
          // Background content
          const Center(
            child: Text(
              'Tap the menu icon to see the staggered animation.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          // Drawer overlay
          AnimatedBuilder(
            animation: _drawerSlideController,
            builder: (context, child) {
              if (_drawerSlideController.value == 0) {
                return const SizedBox.shrink(); // Hide entirely when not active
              }
              return Container(
                width: 250,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: child,
              );
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < _menuTitles.length; i++)
                      _buildDrawerItem(i, _menuTitles[i]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
