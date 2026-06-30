import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_bloc.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_event.dart';
import 'package:zingo/core/blocs/user/update-favorite-dialog/update_favorite_dialog_bloc.dart';
import 'package:zingo/core/blocs/user/update-favorite-dialog/update_favorite_dialog_event.dart';
import 'package:zingo/core/blocs/user/update-favorite-dialog/update_favorite_dialog_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/dtos/users/users_favorite_dialog_dto.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';

class FavoriteDialogTrigger extends StatefulWidget {
  final String dialogId;
  final bool isFavorite;

  const FavoriteDialogTrigger({
    super.key,
    required this.dialogId,
    this.isFavorite = false,
  });

  @override
  State<FavoriteDialogTrigger> createState() => _FavoriteDialogTriggerState();
}

class _FavoriteDialogTriggerState extends State<FavoriteDialogTrigger> {
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isFavorite = widget.isFavorite;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _toggle(BuildContext context) {
    final userId = context.read<AuthBloc>().state.data?.id;
    if (userId == null) return;

    final payload = UsersFavoriteDialogDto(
      dialog_id: widget.dialogId,
      user_id: userId,
    );
    if (isFavorite) {
      context.read<FavoriteDialogBloc>().add(
        FavoriteDialogRemoveEvent(payload: payload),
      );
    } else {
      context.read<FavoriteDialogBloc>().add(
        FavoriteDialogAddEvent(payload: payload),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteDialogBloc, FavoriteDialogState>(
      listenWhen: (prev, curr) => prev.requestStatus != curr.requestStatus,
      listener: (context, state) {
        if (state.requestStatus != RequestStatus.success) return;

        setState(() {
          isFavorite = state.isFavorite;
        });

        final userId = context.read<AuthBloc>().state.data?.id;
        context.read<ListFavoriteDialogsBloc>().add(
          ListFavoriteDialogsRefreshEvent(userId: userId),
        );
      },
      builder: (context, state) {
        final isLoading = state.requestStatus == RequestStatus.loading;
        return IconButton(
          onPressed: isLoading ? null : () => _toggle(context),
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isFavorite
                      ? AppColors.favorite
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
