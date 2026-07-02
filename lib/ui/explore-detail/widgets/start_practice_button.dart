import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/start-practice/start_practice_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/start-practice/start_practice_event.dart';
import 'package:zingo/core/blocs/practice-sessions/start-practice/start_practice_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/domain/dtos/practice-sessions/create_session_payload.dart';
import 'package:zingo/domain/models/dialog.dart' as dialog_model;
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/ui/dialogs/permission_dialog.dart';
import 'package:zingo/utils/permission_handler_service.dart';

class StartPracticeButton extends StatelessWidget {
  const StartPracticeButton({
    super.key,
    required this.selectedMode,
    this.dialog,
    this.suggestionDialogId,
  });

  final PracticeMode selectedMode;
  final dialog_model.Dialog? dialog;
  final String? suggestionDialogId;

  Future<void> _onStartPractice(BuildContext context) async {
    // speech maps to mic on Android, speech recognition on iOS
    final micStatus = await PermissionHandlerService.requestPermission(
      permission: Permission.microphone,
    );
    final speechStatus = await PermissionHandlerService.requestPermission(
      permission: Permission.speech,
    );

    final granted = micStatus.isGranted && speechStatus.isGranted;
    if (!granted) {
      // Only deep-link to settings when the OS won't prompt again.
      // Otherwise the request() above already surfaced the prompt.
      final permanentlyDenied =
          micStatus.isPermanentlyDenied || speechStatus.isPermanentlyDenied;
      if (permanentlyDenied && context.mounted) {
        final openSettings = await PermissionDialog.show(context);
        // Opens this app's own settings page (not the generic Settings root).
        if (openSettings) {
          await AppSettings.openAppSettings(type: AppSettingsType.settings);
        }
      }
      return;
    }

    if (!context.mounted) return;
    if (dialog?.id == null) {
      context.go("/learn");
    }
    context.read<StartPracticeBloc>().add(
      StartPracticeSubmit(
        payload: CreateSessionPayload(
          user_id: context.read<AuthBloc>().state.data?.id ?? '',
          dialog_id: dialog?.id ?? "",
          practice_mode: selectedMode.value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StartPracticeBloc, StartPracticeState>(
      listener: (context, state) {
        if (state.requestStatus == RequestStatus.success) {
          // go to practice screen
          context.pushReplacement(
            '/practice',
            extra: {
              'practice_session_id': state.data?.id ?? '',
              'dialog_id': state.data?.dialog_id ?? dialog?.id ?? "",
              'pracetice_mode': state.data?.practice_mode ?? selectedMode.value,
              'dialog': dialog,
              'suggestion_dialog_id': suggestionDialogId,
            },
          );
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  _onStartPractice(context);
                },
                icon: state.requestStatus == RequestStatus.loading
                    ? const CircularProgressIndicator.adaptive()
                    : const Icon(Icons.mic_outlined),
                label: state.requestStatus == RequestStatus.loading
                    ? Text(context.l10n.startingPractice)
                    : Text(context.l10n.practiceStart),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.white,
                  elevation: 4,
                  shadowColor: AppColors.accentLight.withAlpha(150),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  TextSpan(text: "${selectedMode.label} · "),
                  TextSpan(
                    text: '+${dialog?.xp_points ?? 0} XP',
                    style: const TextStyle(
                      color: AppColors.xp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
