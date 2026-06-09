import 'package:go_router/go_router.dart';
import 'package:tripmate/core/router/main_screen.dart';
import 'package:tripmate/features/explore/explore_screen.dart';
import 'package:tripmate/features/notifications/notification_screen.dart';
import 'package:tripmate/features/settings/setting_screen.dart';
import 'package:tripmate/features/trips/triplist_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/trips',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(
          path: '/trips',
          builder: (context, state) => const TripListScreen(),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExploreScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingScreen(),
        )
      ]
    )
  ]
);