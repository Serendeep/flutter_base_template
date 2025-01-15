import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
part 'base_bloc_event.dart';
part 'base_bloc_state.dart';

abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  final Logger logger = Logger();
  bool _isDisposed = false;

  BaseBloc(State initialState) : super(initialState) {
    on<Event>((event, emit) async {
      try {
        logger.d('Processing event: ${event.runtimeType}');
        await handleEvent(event, emit);
      } catch (error, stackTrace) {
        logger.e(
          'Error processing event: ${event.runtimeType}',
          error: error,
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
    logger.e('Error in bloc', error: error, stackTrace: stackTrace);
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
