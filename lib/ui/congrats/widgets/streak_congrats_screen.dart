import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_event.dart';
import 'package:zingo/core/blocs/user/get-streak/user_streak_get_bloc.dart';
import 'package:zingo/core/blocs/user/get-streak/user_streak_get_event.dart';
import 'package:zingo/domain/dtos/user-streak/get_user_streak_payload.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/domain/models/completed_practice_session.dart';
import 'package:zingo/ui/core/ui/streak_week_view.dart';

class StreakCongratsScreen extends StatefulWidget {
  const StreakCongratsScreen({super.key, this.session});

  final CompletedPracticeSession? session;

  @override
  State<StreakCongratsScreen> createState() => _StreakCongratsScreenState();
}

class _StreakCongratsScreenState extends State<StreakCongratsScreen>
    with TickerProviderStateMixin {
  static const _levelUpSoundAsset = 'assets/level-up.aac';
  static const _levelUpSoundDuration = Duration(milliseconds: 1886);

  late final AudioPlayer _audioPlayer;
  late final AnimationController _lottieController;
  late final AnimationController _statsController;
  late final AnimationController _firesController;
  late final AnimationController _buttonController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _translateAnimation;
  late final Animation<double> _statsFade;
  late final Animation<Offset> _statsSlide;
  late final Animation<double> _monthYearFade;
  late final List<Animation<double>> _fireCellAnimations;
  late final Animation<double> _buttonFade;

  UserConfigurationGetBloc get _userConfigurationGetBloc =>
      context.read<UserConfigurationGetBloc>();

  bool _animationsComplete = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _lottieController = AnimationController(
      vsync: this,
      duration: _levelUpSoundDuration,
    );
    _statsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _firesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    final curved = CurvedAnimation(
      parent: _lottieController,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.3,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_lottieController);

    _translateAnimation = Tween<double>(
      begin: 0.0,
      end: -170.0,
    ).animate(curved);

    _statsFade = CurvedAnimation(
      parent: _statsController,
      curve: Curves.easeOut,
    );
    _statsSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(_statsFade);

    _monthYearFade = CurvedAnimation(
      parent: _firesController,
      curve: const Interval(0, 0.25, curve: Curves.easeOut),
    );

    _fireCellAnimations = List.generate(7, (i) {
      final start = 0.15 + (i * 0.1);
      final end = (start + 0.45).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _firesController,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      );
    });

    _buttonFade = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOut,
    );

    _lottieController.addStatusListener(_onLottieStatus);
    _statsController.addStatusListener(_onStatsStatus);
    _firesController.addStatusListener(_onFiresStatus);
    _buttonController.addStatusListener(_onButtonStatus);
    unawaited(_startExperience());
  }

  Future<void> _startExperience() async {
    try {
      await _audioPlayer.setAsset(_levelUpSoundAsset);
      final soundDuration = _audioPlayer.duration ?? _levelUpSoundDuration;
      if (soundDuration != _lottieController.duration) {
        _lottieController.duration = soundDuration;
      }
      unawaited(_audioPlayer.play());
    } catch (_) {
      // Fall back to the measured asset duration if playback fails to load.
    }

    if (!mounted) return;
    _lottieController.forward(from: 0);
  }

  void _onLottieStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _statsController.forward();
    }
  }

  void _onStatsStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _firesController.forward();
    }
  }

  void _onFiresStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _buttonController.forward();
    }
  }

  void _onButtonStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() => _animationsComplete = true);
    }
  }

  void _onContinuePressed() {
    final userId = widget.session?.user_id ?? '';
    context.go('/home');
    _userConfigurationGetBloc.add(
      UserConfigurationGetFetched(userId: userId),
    );
    context.read<UserStreakGetBloc>().add(
      UserStreakGetFetched(
        payload: GetUserStreakPayload(
          user_id: userId,
          year: DateTime.now().year,
        ),
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_audioPlayer.stop());
    _audioPlayer.dispose();
    _lottieController.dispose();
    _statsController.dispose();
    _firesController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _lottieController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _translateAnimation.value),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Lottie.asset('assets/streak-fire.json', repeat: true),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 180),
                _StatsCard(
                  session: session,
                  statsFade: _statsFade,
                  statsSlide: _statsSlide,
                  monthYearFade: _monthYearFade,
                  fireCellAnimations: _fireCellAnimations,
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _buttonFade,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(_buttonFade),
                    child: IgnorePointer(
                      ignoring: !_animationsComplete,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _animationsComplete
                                ? _onContinuePressed
                                : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              context.l10n.continueLabel,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.session,
    required this.statsFade,
    required this.statsSlide,
    required this.monthYearFade,
    required this.fireCellAnimations,
  });

  final CompletedPracticeSession? session;
  final Animation<double> statsFade;
  final Animation<Offset> statsSlide;
  final Animation<double> monthYearFade;
  final List<Animation<double>> fireCellAnimations;

  @override
  Widget build(BuildContext context) {
    final streakDates = session?.user_streak?.streak_dates ?? {};
    final today = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FadeTransition(
        opacity: statsFade,
        child: SlideTransition(
          position: statsSlide,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              spacing: 20,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(
                      icon: Icons.star_rounded,
                      color: AppColors.xp,
                      value: '+${session?.xp ?? 0}',
                      label: context.l10n.xpEarned,
                    ),
                    Container(width: 1, height: 48, color: AppColors.divider),
                    _StatItem(
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.streak,
                      value: '${session?.streak ?? 0}',
                      label: context.l10n.currentStreak,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeTransition(
                      opacity: monthYearFade,
                      child: Text(
                        StreakWeekView.monthYearLabel(today),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    StreakWeekView(
                      streakDates: streakDates,
                      referenceDate: today,
                      cellAnimations: fireCellAnimations,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        Icon(icon, color: color, size: 28),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
