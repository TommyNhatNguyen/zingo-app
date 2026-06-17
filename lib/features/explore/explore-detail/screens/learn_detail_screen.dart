import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/dialog/detail/dialog_detail_bloc.dart';
import 'package:zingo/blocs/dialog/detail/dialog_detail_event.dart';
import 'package:zingo/blocs/dialog/detail/dialog_detail_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/dialog/dialog_detail_payload.dart';
import 'package:zingo/features/explore/explore-detail/widgets/dialog_detail_scoring.dart';
import 'package:zingo/features/explore/explore-detail/widgets/dialog_detail_title.dart';
import 'package:zingo/features/explore/explore-detail/widgets/learn_detail_app_bar.dart';
import 'package:zingo/features/explore/explore-detail/widgets/practice_mode_form.dart';
import 'package:zingo/features/explore/explore-detail/widgets/practice_mode_preview.dart';
import 'package:zingo/features/explore/explore-detail/widgets/start_practice_button.dart';
import 'package:zingo/features/explore/explore-detail/widgets/youll_be_scored_on.dart';

class LearnDetailScreen extends StatefulWidget {
  final String id;

  const LearnDetailScreen({super.key, required this.id});

  @override
  State<LearnDetailScreen> createState() => _LearnDetailScreenState();
}

class _LearnDetailScreenState extends State<LearnDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  PracticeMode _selectedMode = PracticeMode.readAloud;
  bool _isHideNavbar = false;
  bool _isAtTop = true;

  DialogDetailBloc get bloc => context.read<DialogDetailBloc>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    bloc.add(
      DialogDetailFetchEvent(
        payload: DialogDetailPayload(
          id: widget.id ?? "13febbdf-a74c-4904-bc3b-c22bdec6a327",
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels <= 180) {
      setState(() => _isAtTop = true);
    } else {
      setState(() => _isAtTop = false);
    }

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_isHideNavbar) setState(() => _isHideNavbar = true);
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_isHideNavbar) setState(() => _isHideNavbar = false);
    }
  }

  void _onModeSelected(PracticeMode mode) {
    setState(() => _selectedMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DialogDetailBloc, DialogDetailState>(
      listener: (context, state) {
        if (state.requestStatus == RequestStatus.error) {
          Toastification().show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: const Text('Error'),
            description: Text(state.error ?? 'An error occurred'),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Skeletonizer(
            enabled: state.requestStatus == RequestStatus.loading,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      LearnDetailAppBar(data: state.data, isAtTop: _isAtTop),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                            bottom: 32,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8,
                            children: [
                              DialogDetailTitle(dialog: state.data),
                              DialogDetailScoring(dialog: state.data),
                              PracticeModeForm(
                                selectedMode: _selectedMode,
                                onModeSelected: _onModeSelected,
                              ),
                              PracticeModePreview(selectedMode: _selectedMode),
                              YoullBeScoredOn(selectedMode: _selectedMode),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transformAlignment: AlignmentGeometry.xy(
                      0,
                      _isHideNavbar ? 1 : 0,
                    ),
                    transform: Matrix4.translationValues(
                      0,
                      _isHideNavbar ? 100 : 0,
                      0,
                    ),
                    curve: Curves.ease,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: StartPracticeButton(
                      selectedMode: _selectedMode,
                      dialog: state.data,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
