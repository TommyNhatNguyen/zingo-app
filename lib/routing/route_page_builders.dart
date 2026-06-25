import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class RoutePageBuilders {
  static Page<dynamic> noTransition(LocalKey key, Widget child) =>
      NoTransitionPage(key: key, child: child);

  static Page<dynamic> fade(LocalKey key, Widget child) => CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
          child: child,
        ),
  );

  static Page<dynamic> slideFromBottom(LocalKey key, Widget child) =>
      CustomTransitionPage(
        key: key,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}
