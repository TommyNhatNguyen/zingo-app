import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/user/get/users_bloc.dart';
import 'package:zingo/routing/route_page_builders.dart';
import 'package:zingo/ui/auth/register/widgets/register_screen.dart';

class RegisterRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/register',
    pageBuilder: (context, state) => RoutePageBuilders.noTransition(
      state.pageKey,
      BlocProvider(create: (_) => UsersBloc(), child: const RegisterScreen()),
    ),
  );
}
