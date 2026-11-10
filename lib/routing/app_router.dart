import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yha/features/about/presentation/screens/about_screen.dart';
import 'package:yha/features/auth/presentation/screens/profile_screen.dart';
import 'package:yha/features/auth/presentation/screens/student_login_screen.dart';
import 'package:yha/features/course_detail/presentation/screens/course_detail_screen.dart';
import 'package:yha/features/courses/presentation/screens/courses_screen.dart';
import 'package:yha/features/home/presentation/screens/home_screen.dart';
import 'package:yha/features/project_detail/presentation/screens/project_detail_screen.dart';
import 'package:yha/features/projects/data/models/project_model.dart';
import 'package:yha/features/projects/presentation/screens/projects_screen.dart';
import 'package:yha/features/shell/presentation/main_shell_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const StudentLoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/courses',
              builder: (context, state) => const CoursesScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'courseDetail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                    return CourseDetailScreen(courseId: id);
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/projects',
              builder: (context, state) => const ProjectsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'projectDetail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                    final extra = state.extra;
                    return ProjectDetailScreen(
                      projectId: id,
                      project: extra is ProjectModel ? extra : null,
                    );
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/about',
              builder: (context, state) => const AboutScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
}
