import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gpteacher/features/home/view/home.view.dart';
import 'package:gpteacher/routing/not_found_screen.dart';

import '../features/test/view/test.view.dart';

enum AppRoute { home, test }

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    // redirect: (context, state) => routerRedirections(
    //     context, state, ref.read(authRepositoryProvider).authStateChange()),
    // refreshListenable: GoRouterRefreshStream(
    //     ref.read(authRepositoryProvider).authStateChange()),
    routes: [
      GoRoute(
          path: '/',
          name: AppRoute.home.name,
          builder: (context, state) => const HomeView(),
          routes: [
            GoRoute(
                path: 'test',
                name: AppRoute.test.name,
                builder: (context, state) => const TestGPTView()),
            // GoRoute(
            //     path: 'displayConversation/:id',
            //     name: AppRoute.displayConversation.name,
            //     builder: (context, state) {
            //       final conversationId = state.params['id'];
            //       print(conversationId);
            //       //ConversationWithMembers conversation = state.params['conversationBinded']; //from json
            //       return DisplayConversation(conversationId: conversationId);
            //     }),
          ])
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
