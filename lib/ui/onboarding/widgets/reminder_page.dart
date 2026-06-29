import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zingo/core/blocs/notification-permisison/notification_permission_cubit.dart';
import 'package:zingo/core/constants/notification_time.dart';
import 'package:zingo/core/constants/practice_goal.dart';
import 'package:zingo/ui/core/ui/card_select.dart';
import 'package:zingo/ui/core/ui/pickers/time_picker.dart';
import 'package:zingo/ui/core/ui/switcher.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_bloc.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_event.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_state.dart';
import 'package:zingo/utils/notification_service.dart';
import 'package:zingo/utils/permission_handler_service.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  NotificationPermissionCubit get _notiPermissionCubit =>
      context.read<NotificationPermissionCubit>();

  void _onPracticeGoalChanged({
    required BuildContext context,
    required PracticeGoal goal,
  }) {
    context.read<OnboardingViewBloc>().add(
      OnboardingViewUpdateForm(practiceGoalPerDay: goal.value),
    );
  }

  void _onNotificationTimeChanged({
    required BuildContext context,
    required TimeOfDay? time,
  }) {
    context.read<OnboardingViewBloc>().add(
      OnboardingViewUpdateForm(notificationTime: time),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingViewBloc>().state;
    final textTheme = Theme.of(context).textTheme;
    final notificationService = NotificationService();
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          _buildGoal(textTheme, state, context),
          _buildNotification(textTheme, notificationService, state, context),
        ],
      ),
    );
  }

  Widget _buildNotification(
    TextTheme textTheme,
    NotificationService notificationService,
    OnboardingViewState state,
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🔔', style: textTheme.headlineLarge?.copyWith(fontSize: 40)),
            Text(
              "Let us increase your chances of practicing daily",
              style: textTheme.headlineMedium,
            ),
          ],
        ),
        BlocConsumer<NotificationPermissionCubit, bool>(
          listener: (context, isGranted) {
            if (isGranted) {
              _onNotificationTimeChanged(context: context, time: null);
            }
          },
          builder: (context, isGranted) {
            return Column(
              spacing: 8,
              children: [
                Switcher(
                  value: isGranted,
                  onChanged: (value) async {
                    if (!isGranted) {
                      final status =
                          await PermissionHandlerService.requestPermission(
                            permission: Permission.notification,
                          );
                      final settings = await notificationService
                          .requestPermission();
                      if (settings != null &&
                          status == PermissionStatus.granted) {
                        _notiPermissionCubit.setPermission(true);
                        debugPrint("Notification status: $status");
                        debugPrint(
                          "Notification settings: ${settings.authorizationStatus}",
                        );
                        debugPrint("Notification is granted: $isGranted");
                      } else {
                        debugPrint("Failed to request notification permission");
                        _notiPermissionCubit.setPermission(false);
                      }
                    } else {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Disable notifications"),
                          content: Text(
                            "You will not receive any notifications from the app. Are you sure you want to disable notifications?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text("Disable"),
                            ),
                          ],
                        ),
                      );
                      if (result == true) {
                        _notiPermissionCubit.setPermission(false);
                      }
                    }
                  },
                  label: Text(
                    "🔔 Enable daily reminders",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        BlocBuilder<NotificationPermissionCubit, bool>(
          builder: (context, isGranted) {
            if (!isGranted) return const SizedBox.shrink();
            return Column(
              spacing: 8,
              children: [
                TimePicker(
                  value: state.notificationTime,
                  onConfirm: (time) => {
                    if (time != null)
                      {
                        _onNotificationTimeChanged(
                          context: context,
                          time: time,
                        ),
                      },
                  },
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.4,
                  crossAxisCount: 2,
                  children: NotificationTime.all.map((item) {
                    return CardSelect(
                      emoji: item.emoji,
                      label: item.label,
                      isSelected: state.notificationTime == item.value,
                      onTap: () => _onNotificationTimeChanged(
                        context: context,
                        time: item.value,
                      ),
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      labelMaxLines: 2,
                      checkIconSize: 16,
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildGoal(
    TextTheme textTheme,
    OnboardingViewState state,
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎯', style: textTheme.headlineLarge?.copyWith(fontSize: 40)),
            Text("Setup your goal", style: textTheme.headlineMedium),
          ],
        ),
        Flexible(
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 2,
            crossAxisCount: 2,
            children: PracticeGoal.all
                .map(
                  (goal) => CardSelect(
                    emoji: goal.emoji,
                    label: goal.label,
                    isSelected: state.practiceGoalPerDay == goal.value,
                    onTap: () =>
                        _onPracticeGoalChanged(context: context, goal: goal),
                    emojiStyle: Theme.of(context).textTheme.displayMedium,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
