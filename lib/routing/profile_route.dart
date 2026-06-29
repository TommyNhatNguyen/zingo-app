import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/user/update-configuration/user_configuration_update_bloc.dart';
import 'package:zingo/ui/profile-setting/blocs/user_profile_view_bloc.dart';
import 'package:zingo/ui/profile-setting/widgets/user_profile_anonymous_screen.dart';
import 'package:zingo/ui/profile-setting/widgets/user_profile_screen.dart';

class ProfileRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/profile',
    builder: (context, state) {
      final authUserData = context.read<AuthBloc>().state.user;
      final isAnonymous = authUserData?.isAnonymous ?? true;
      return isAnonymous
          ? const UserProfileAnonymousScreen()
          : MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => UserConfigurationUpdateBloc()),
                BlocProvider(create: (_) => UserProfileViewBloc()),
              ],
              child: const UserProfileScreen(),
            );
    },
  );
}
