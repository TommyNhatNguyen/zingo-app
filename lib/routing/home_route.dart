import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/recommendations/journey/journey_bloc.dart';
import 'package:zingo/core/blocs/recommendations/journey/journey_event.dart';
import 'package:zingo/domain/dtos/journey/journey_payload.dart';
import 'package:zingo/routing/route_page_builders.dart';
import 'package:zingo/ui/home/widgets/home_screen.dart';

class HomeRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/home',
    pageBuilder: (context, state) => RoutePageBuilders.fade(
      state.pageKey,
      BlocProvider(
        create: (context) => JourneyBloc()
          ..add(
            JourneyFetchEvent(
              payload: JourneyPayload(
                user_id: context.read<AuthBloc>().state.data?.id ?? '',
              ),
            ),
          ),
        child: HomeScreen(),
      ),
    ),
  );
}
