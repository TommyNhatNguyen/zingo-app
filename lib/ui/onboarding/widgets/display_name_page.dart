import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_bloc.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_event.dart';

class DisplayNamePage extends StatelessWidget {
  const DisplayNamePage({super.key});

  void _onDisplayNameChanged({
    required BuildContext context,
    required String value,
  }) {
    context.read<OnboardingViewBloc>().add(
      OnboardingViewUpdateForm(displayName: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        spacing: 16,
        children: [
          Row(
            spacing: 8,
            children: [
              Text("👋", style: Theme.of(context).textTheme.headlineLarge),
              Text(
                "What should we call you?",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
          TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: l10n.enterNameHint),
            onChanged: (value) {
              _onDisplayNameChanged(context: context, value: value);
            },
          ),
        ],
      ),
    );
  }
}
