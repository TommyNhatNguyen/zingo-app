import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/connectivity/connectivity_event.dart';
import 'package:zingo/core/blocs/connectivity/connectivity_state.dart';
import 'package:zingo/utils/debounce_util.dart';

class _ConnectivityDisconnectedEvent extends ConnectivityEvent {
  final List<ConnectivityResult>? connectivityResult;
  const _ConnectivityDisconnectedEvent({this.connectivityResult});
  @override
  List<Object?> get props => [connectivityResult];
}

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final _debouncer = DebounceUtil(milliseconds: 500);

  ConnectivityBloc() : super(ConnectivityState.initial()) {
    on<ConnectivityCheckEvent>((event, emit) {
      if (event.isConnected == true) {
        _debouncer.dispose();
        emit(
          state.copyWith(
            connectivityResult: event.connectivityResult,
            isConnected: true,
          ),
        );
      } else {
        _debouncer.run(() {
          if (!isClosed) {
            add(
              _ConnectivityDisconnectedEvent(
                connectivityResult: event.connectivityResult,
              ),
            );
          }
        });
      }
    });

    on<_ConnectivityDisconnectedEvent>((event, emit) {
      emit(
        state.copyWith(
          connectivityResult: event.connectivityResult,
          isConnected: false,
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }
}
