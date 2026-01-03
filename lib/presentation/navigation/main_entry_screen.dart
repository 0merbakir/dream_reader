import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_reader/features/dream/presentation/dream_screen.dart';
import 'package:dream_reader/features/insights/presentation/insights_screen.dart';
import 'package:dream_reader/features/nebula/presentation/nebula_screen.dart';
import 'package:dream_reader/presentation/navigation/navigation_provider.dart';
import 'package:dream_reader/core/utils/responsive_layout.dart';

class MainEntryScreen extends ConsumerWidget {
  const MainEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);
    final notifier = ref.read(navigationIndexProvider.notifier);

    final screens = [
      const DreamScreen(),
      const NebulaScreen(),
      const InsightsScreen(),
      const Scaffold(backgroundColor: Colors.transparent, body: Center(child: Text("Profile (Coming Soon)", style: TextStyle(color: Colors.white)))),
    ];

    return Scaffold(
      backgroundColor: Colors.black, // Dark background for the whole app
      body: Row(
        children: [
          // Desktop/Web Navigation Rail
          if (ResponsiveLayout.isDesktop(context) || ResponsiveLayout.isTablet(context))
            NavigationRail(
              backgroundColor: Colors.black.withValues(alpha: 0.8),
              selectedIndex: selectedIndex,
              onDestinationSelected: notifier.setIndex,
              labelType: NavigationRailLabelType.all,
              selectedLabelTextStyle: GoogleFonts.orbitron(color: const Color(0xFF00F0FF), fontSize: 12),
              unselectedLabelTextStyle: GoogleFonts.orbitron(color: Colors.white54, fontSize: 10),
              useIndicator: true,
              indicatorColor: const Color(0xFF00F0FF).withValues(alpha: 0.2),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.auto_awesome, color: Colors.white54),
                  selectedIcon: Icon(Icons.auto_awesome, color: Color(0xFF00F0FF)),
                  label: Text('Dream'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.grid_view, color: Colors.white54),
                  selectedIcon: Icon(Icons.grid_view, color: Color(0xFF00F0FF)),
                  label: Text('Nebula'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.insights, color: Colors.white54),
                  selectedIcon: Icon(Icons.insights, color: Color(0xFF00F0FF)),
                  label: Text('Insights'),
                ),
                 NavigationRailDestination(
                  icon: Icon(Icons.person, color: Colors.white54),
                  selectedIcon: Icon(Icons.person, color: Color(0xFF00F0FF)),
                  label: Text('Profile'),
                ),
              ],
            ),
          
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: (ResponsiveLayout.isMobile(context))
          ? Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ]
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.black.withValues(alpha: 0.9), // Almost opaque for mobile readability
                type: BottomNavigationBarType.fixed,
                currentIndex: selectedIndex,
                onTap: notifier.setIndex,
                selectedItemColor: const Color(0xFF00F0FF),
                unselectedItemColor: Colors.white54,
                selectedLabelStyle: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold),
                unselectedLabelStyle: GoogleFonts.orbitron(fontSize: 10),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.auto_awesome),
                    label: 'Dream',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.grid_view),
                    label: 'Nebula',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.insights),
                    label: 'Insights',
                  ),
                   BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
