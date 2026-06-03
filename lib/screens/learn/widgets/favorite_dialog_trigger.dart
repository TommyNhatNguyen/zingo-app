import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/users/favorite-dialog/favorite_dialog_bloc.dart';
import 'package:zingo/blocs/users/favorite-dialog/favorite_dialog_event.dart';
import 'package:zingo/blocs/users/favorite-dialog/favorite_dialog_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/users/users_favorite_dialog_dto.dart';

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
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _onPressed(BuildContext context, FavoriteDialogState state) {
    final authData = context.read<AuthBloc>().state.data;
    if (authData == null) return;
    final payload = UsersFavoriteDialogDto(
      dialog_id: widget.dialogId,
      user_id: authData.id,
    );
    final bloc = context.read<FavoriteDialogBloc>();

    if (_isFavorite) {
      bloc.add(FavoriteDialogRemoveEvent(payload: payload));
    } else {
      bloc.add(FavoriteDialogAddEvent(payload: payload));
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoriteDialogBloc(),
      child: BlocConsumer<FavoriteDialogBloc, FavoriteDialogState>(
        listener: (context, state) {
          if (state.requestStatus == RequestStatus.success) {
            setState(() {
              _isFavorite = state.isFavorite;
            });
          } else if (state.requestStatus == RequestStatus.error) {
            setState(() {
              _isFavorite = false;
            });
          }
        },
        builder: (context, state) {
          return IconButton(
            onPressed: () => _onPressed(context, state),
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_outline,
              color: _isFavorite ? AppColors.primary : AppColors.textSecondary,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          );
        },
      ),
    );
  }
}
