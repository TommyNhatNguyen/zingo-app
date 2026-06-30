import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_event.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_state.dart';
import 'package:zingo/ui/core/ui/pickers/cefr_level_filter_picker.dart';
import 'package:zingo/ui/core/ui/pickers/duration_filter_picker.dart';
import 'package:zingo/ui/core/ui/pickers/topic_filter_picker.dart';

class RecommendationFilter extends StatelessWidget {
  const RecommendationFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DialogListBloc, DialogListState>(
      builder: (context, state) {
        final bloc = context.read<DialogListBloc>();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8,
            children: [
              CefrLevelFilterPicker(
                value: state.cefrLevels,
                onChanged: (levels) => bloc.add(
                  DialogListFiltersChanged(
                    cefrLevels: levels,
                    durations: state.durations,
                    topicIds: state.topicIds,
                  ),
                ),
              ),
              DurationFilterPicker(
                value: state.durations,
                onChanged: (durations) => bloc.add(
                  DialogListFiltersChanged(
                    cefrLevels: state.cefrLevels,
                    durations: durations,
                    topicIds: state.topicIds,
                  ),
                ),
              ),
              TopicFilterPicker(
                value: state.topicIds,
                onChanged: (topicIds) => bloc.add(
                  DialogListFiltersChanged(
                    cefrLevels: state.cefrLevels,
                    durations: state.durations,
                    topicIds: topicIds,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
