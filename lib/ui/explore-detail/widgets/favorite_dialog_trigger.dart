import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/user/update-favorite-dialog/update_favorite_dialog_bloc.dart';
import 'package:zingo/core/blocs/user/update-favorite-dialog/update_favorite_dialog_event.dart';
import 'package:zingo/core/blocs/user/update-favorite-dialog/update_favorite_dialog_state.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/dtos/users/users_favorite_dialog_dto.dart';

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
  late final FavoriteDialogBloc _bloc;
  late bool _isFavorite;
  bool _previousFavorite = false;

  @override
  void initState() {
    super.initState();
    _bloc = FavoriteDialogBloc();
    _isFavorite = widget.isFavorite;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _toggle(BuildContext context) {
    if (_bloc.state.requestStatus == RequestStatus.loading) return;

    final userId = context.read<AuthBloc>().state.data?.id;
    if (userId == null) return;

    _previousFavorite = _isFavorite;
    final payload = UsersFavoriteDialogDto(
      dialog_id: widget.dialogId,
      user_id: userId,
    );

    setState(() => _isFavorite = !_isFavorite);

    if (_previousFavorite) {
      _bloc.add(FavoriteDialogRemoveEvent(payload: payload));
    } else {
      _bloc.add(FavoriteDialogAddEvent(payload: payload));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteDialogBloc, FavoriteDialogState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.requestStatus == RequestStatus.success) {
          setState(() => _isFavorite = !_isFavorite);
        } else if (state.requestStatus == RequestStatus.error) {
          setState(() => _isFavorite = _previousFavorite);
        }
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
                  _isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: _isFavorite
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
