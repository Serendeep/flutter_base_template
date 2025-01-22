import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:flutter_base_template/core/error/app_error.dart';
part 'base_bloc_event.dart';
part 'base_bloc_state.dart';

abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  final Logger logger = Logger();
  bool _isDisposed = false;

  BaseBloc(super.initialState) {
    on<Event>((event, emit) async {
      try {
        logger.d('Processing event: ${event.runtimeType}');
        await handleEvent(event, emit);
      } catch (error, stackTrace) {
        AppError.create(
          message: 'Error processing event: ${event.runtimeType}',
          type: ErrorType.unknown,
          originalError: error,
          stackTrace: stackTrace,
        );
        await handleError(error, stackTrace, emit);
      }
    });
  }

  /// Override this method to handle events in the implementing bloc
  Future<void> handleEvent(Event event, Emitter<State> emit);

  /// Override this method to customize error handling in the implementing bloc
  Future<void> handleError(
    dynamic error,
    StackTrace stackTrace,
    Emitter<State> emit,
  ) async {
    // Default error handling
    AppError.create(
      message: 'Error in bloc',
      type: ErrorType.unknown,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  @override
  Future<void> close() async {
    if (!_isDisposed) {
      _isDisposed = true;
      await super.close();
    }
  }

  bool get isDisposed => _isDisposed;
}
