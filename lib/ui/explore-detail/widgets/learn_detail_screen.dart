import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/core/blocs/dialog/detail/dialog_detail_bloc.dart';
import 'package:zingo/core/blocs/dialog/detail/dialog_detail_event.dart';
import 'package:zingo/core/blocs/dialog/detail/dialog_detail_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/domain/dtos/dialog/dialog_detail_payload.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/explore-detail/blocs/learn_detail_view_bloc.dart';
import 'package:zingo/ui/explore-detail/blocs/learn_detail_view_event.dart';
import 'package:zingo/ui/explore-detail/blocs/learn_detail_view_state.dart';
import 'package:zingo/ui/explore-detail/widgets/dialog_detail_scoring.dart';
import 'package:zingo/ui/explore-detail/widgets/dialog_detail_title.dart';
import 'package:zingo/ui/explore-detail/widgets/learn_detail_app_bar.dart';
import 'package:zingo/ui/explore-detail/widgets/practice_mode_form.dart';
import 'package:zingo/ui/explore-detail/widgets/start_practice_button.dart';
import 'package:zingo/ui/explore-detail/widgets/youll_be_scored_on.dart';

class LearnDetailScreen extends StatefulWidget {
  final String id;

  const LearnDetailScreen({super.key, required this.id});

  @override
  State<LearnDetailScreen> createState() => _LearnDetailScreenState();
}

class _LearnDetailScreenState extends State<LearnDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  late final LearnDetailViewBloc _viewBloc = LearnDetailViewBloc();

  DialogDetailBloc get _dialogBloc => context.read<DialogDetailBloc>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _dialogBloc.add(
      DialogDetailFetchEvent(payload: DialogDetailPayload(id: widget.id)),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _viewBloc.close();
    super.dispose();
  }

  void _handleScroll() {
    final pixels = _scrollController.position.pixels;
    final direction = _scrollController.position.userScrollDirection;

    bool? isHideNavbar;
    if (direction == ScrollDirection.reverse) {
      isHideNavbar = true;
    } else if (direction == ScrollDirection.forward) {
      isHideNavbar = false;
    }

    _viewBloc.add(
      LearnDetailViewUpdateScroll(
        isAtTop: pixels <= 180,
        isHideNavbar: isHideNavbar,
      ),
    );
  }

  Future<void> _onRefresh() async {
    _dialogBloc.add(
      DialogDetailFetchEvent(payload: DialogDetailPayload(id: widget.id)),
    );
  }

  void _onModeSelected(PracticeMode mode) {
    _viewBloc.add(LearnDetailViewSelectMode(mode: mode));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewBloc,
      child: BlocConsumer<DialogDetailBloc, DialogDetailState>(
        listener: (context, state) {
          if (state.requestStatus == RequestStatus.error) {
            Toastification().show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flat,
              title: Text(context.l10n.errorGeneric),
              description: Text(state.error ?? context.l10n.errorGeneric),
              autoCloseDuration: const Duration(seconds: 4),
            );
          }
        },
        builder: (context, dialogState) {
          return BlocBuilder<LearnDetailViewBloc, LearnDetailViewState>(
            bloc: _viewBloc,
            builder: (context, viewState) {
              return Scaffold(
                body: Skeletonizer(
                  enabled: dialogState.requestStatus == RequestStatus.loading,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: CustomScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              LearnDetailAppBar(
                                data: dialogState.data,
                                isAtTop: viewState.isAtTop,
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 16,
                                    bottom: 32,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 16,
                                    children: [
                                      DialogDetailTitle(
                                        dialog: dialogState.data,
                                      ),
                                      DialogDetailScoring(
                                        dialog: dialogState.data,
                                      ),
                                      PracticeModeForm(
                                        selectedMode: viewState.selectedMode,
                                        onModeSelected: _onModeSelected,
                                      ),
                                      YoullBeScoredOn(
                                        selectedMode: PracticeMode.freeSpeak,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                            viewState.isHideNavbar ? 1 : 0,
                          ),
                          transform: Matrix4.translationValues(
                            0,
                            viewState.isHideNavbar ? 100 : 0,
                            0,
                          ),
                          curve: Curves.ease,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            border: Border(
                              top: BorderSide(color: AppColors.border),
                            ),
                          ),
                          child: StartPracticeButton(
                            selectedMode: viewState.selectedMode,
                            dialog: dialogState.data,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
