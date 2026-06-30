import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/dialog/get-dialog-turns/dialog_turns_list_by_dialog_bloc.dart';
import 'package:zingo/core/blocs/dialog/get-dialog-turns/dialog_turns_list_by_dialog_event.dart';
import 'package:zingo/core/blocs/practice-sessions/complete-practice/complete_practice_bloc.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/dtos/dialog-turns/dialog_turns_by_dialog_id_payload.dart';
import 'package:zingo/domain/models/dialog.dart';
import 'package:zingo/ui/practice/blocs/practice_screen_view_bloc.dart';
import 'package:zingo/ui/practice/blocs/practice_screen_view_event.dart';
import 'package:zingo/ui/practice/widgets/practice_screen.dart';

class PracticeRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/practice',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final practiceSessionId = extra?['practice_session_id'] as String?;
      final dialogId = extra?['dialog_id'] as String?;
      final praceticeMode = extra?['pracetice_mode'] as PracticeMode?;
      final dialog = extra?['dialog'] as Dialog?;
      final suggestionDialogId = extra?['suggestion_dialog_id'] as String?;
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DialogTurnsListByDialogBloc()
              ..add(
                DialogTurnsListByDialogFetchEvent(
                  payload: DialogTurnsByDialogIdPayload(dialogId: dialogId ?? ''),
                ),
              ),
          ),
          BlocProvider(
            create: (context) =>
                PracticeScreenBloc()..add(PracticeScreenInitializeEvent()),
          ),
          BlocProvider(create: (_) => CompletePracticeBloc()),
        ],
        child: PracticeScreen(
          practiceSessionId: practiceSessionId ?? '',
          dialogId: dialogId ?? '',
          practiceMode: praceticeMode ?? PracticeMode.readAloud,
          dialog: dialog,
          suggestionDialogId: suggestionDialogId,
        ),
      );
    },
  );
}
