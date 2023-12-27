import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
                bodySmall: const TextStyle(color: Colors.white),
              ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.black,
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (value) {
            widget.navigationShell.goBranch(value,
                initialLocation: value == widget.navigationShell.currentIndex);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.camera_roll, color: Colors.white),
              selectedIcon: Icon(Icons.camera_roll, color: Colors.white),
              label: "Trending Movies",
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.search, color: Colors.white),
              label: "Search",
            ),
            NavigationDestination(
              icon: Icon(Icons.movie, color: Colors.white),
              selectedIcon: Icon(Icons.movie, color: Colors.white),
              label: "Top Movies",
            ),
            NavigationDestination(
              icon: Icon(Icons.star_outline, color: Colors.white),
              selectedIcon: Icon(Icons.star, color: Colors.white),
              label: "Favorite Movies",
            ),
          ],
        ),
      ),
    );
  }
}
