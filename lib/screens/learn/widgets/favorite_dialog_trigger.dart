import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/users/favorite-dialog/favorite_dialog_bloc.dart';
import 'package:zingo/blocs/users/favorite-dialog/favorite_dialog_event.dart';
import 'package:zingo/blocs/users/favorite-dialog/favorite_dialog_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/users/users_favorite_dialog_dto.dart';

class FavoriteDialogTrigger extends StatelessWidget {
  final String dialogId;
  final bool initialIsFavorite;

  const FavoriteDialogTrigger({
    super.key,
    required this.dialogId,
    this.initialIsFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoriteDialogBloc(initialIsFavorite: initialIsFavorite),
      child: _FavoriteButton(dialogId: dialogId),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final String dialogId;

  const _FavoriteButton({required this.dialogId});

  void _onPressed(BuildContext context, FavoriteDialogState state) {
    final authData = context.read<AuthBloc>().state.data;
    if (authData == null) {
      Toastification().show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: const Text('Error'),
        description: const Text('You must be logged in to favorite a dialog'),
        autoCloseDuration: const Duration(seconds: 4),
      );
      return;
    }

    final payload = UsersFavoriteDialogDto(
      dialog_id: dialogId,
      user_id: authData.id,
    );
    final bloc = context.read<FavoriteDialogBloc>();

    if (state.isFavorite) {
      bloc.add(FavoriteDialogRemoveEvent(payload: payload));
    } else {
      bloc.add(FavoriteDialogAddEvent(payload: payload));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteDialogBloc, FavoriteDialogState>(
      builder: (context, state) {
        final isLoading = state.requestStatus == RequestStatus.loading;
        return IconButton(
          onPressed: isLoading ? null : () => _onPressed(context, state),
          icon: isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              : Icon(
                  state.isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: state.isFavorite
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        );
      },
    );
  }
}
