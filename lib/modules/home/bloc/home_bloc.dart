import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/core/base_bloc.dart';
import 'package:flutter_base_template/core/error/app_error.dart';
import 'package:logger/logger.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  final Logger _logger = Logger();

  HomeBloc() : super(HomeInitial()) {
    on<InitializeHomeEvent>(_onInitialize);
    on<LoadHomeDataEvent>(_onLoadData);
    on<RefreshHomeDataEvent>(_onRefresh);
  }

  Future<void> _onInitialize(
    InitializeHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      _logger.i('Initializing home screen');
      emit(const HomeLoading());

      // Simulated data initialization
      await Future.delayed(const Duration(seconds: 1));

      emit(HomeLoaded(
        title: 'Welcome to Flutter Base Template',
        message: 'Your app is ready to go!',
        lastRefreshed: DateTime.now(),
        data: {
          'users': [
            {'name': 'John Doe', 'email': 'john.doe@example.com'},
            {'name': 'Jane Smith', 'email': 'jane.smith@example.com'},
          ],
          'projects': [
            {'name': 'Flutter Base Template', 'status': 'Active'},
            {'name': 'Mobile App', 'status': 'In Progress'},
          ],
        },
      ));
    } catch (e, stackTrace) {
      await handleError(e, stackTrace, emit);
    }
  }

  Future<void> _onLoadData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      _logger.i('Loading home data');
      emit(HomeLoading(isRefreshing: event.forceRefresh));

      // Simulated data loading with optional force refresh
      await Future.delayed(const Duration(seconds: 1));

      emit(HomeLoaded(
        title: 'Data Loaded Successfully',
        message: event.forceRefresh
            ? 'Data has been forcefully refreshed'
            : 'Home data loaded from cache',
        lastRefreshed: DateTime.now(),
        data: {
          'users': [
            {'name': 'John Doe', 'email': 'john.doe@example.com'},
            {'name': 'Jane Smith', 'email': 'jane.smith@example.com'},
            {'name': 'New User', 'email': 'new.user@example.com'},
          ],
          'projects': [
            {'name': 'Flutter Base Template', 'status': 'Active'},
            {'name': 'Mobile App', 'status': 'In Progress'},
            {'name': 'Web Dashboard', 'status': 'Planning'},
          ],
        },
      ));
    } catch (e, stackTrace) {
      await handleError(e, stackTrace, emit);
    }
  }

  Future<void> _onRefresh(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state;
      _logger.i('Refreshing home data');

      if (currentState is HomeLoaded) {
        emit(const HomeLoading(isRefreshing: true));

        // Simulated data refresh
        await Future.delayed(const Duration(seconds: 1));

        emit(HomeLoaded(
          title: 'Data Refreshed',
          message: 'Latest data fetched successfully',
          lastRefreshed: DateTime.now(),
          data: {
            'users': [
              {'name': 'John Doe', 'email': 'john.doe@example.com'},
              {'name': 'Jane Smith', 'email': 'jane.smith@example.com'},
              {'name': 'New User', 'email': 'new.user@example.com'},
              {'name': 'Admin User', 'email': 'admin@example.com'},
            ],
            'projects': [
              {'name': 'Flutter Base Template', 'status': 'Active'},
              {'name': 'Mobile App', 'status': 'Completed'},
              {'name': 'Web Dashboard', 'status': 'In Progress'},
            ],
          },
        ));
      }
    } catch (e, stackTrace) {
      await handleError(e, stackTrace, emit);
    }
  }

  @override
  Future<void> handleEvent(HomeEvent event, Emitter<HomeState> emit) async {
    // Default event handling (can be overridden if needed)
    if (event is InitializeHomeEvent) {
      await _onInitialize(event, emit);
    } else if (event is LoadHomeDataEvent) {
      await _onLoadData(event, emit);
    } else if (event is RefreshHomeDataEvent) {
      await _onRefresh(event, emit);
    } else {
      emit(const HomeError(message: 'Unknown event type'));
    }
  }

  @override
  Future<void> handleError(
    dynamic error,
    StackTrace stackTrace,
    Emitter<HomeState> emit,
  ) async {
    // Custom error handling for HomeBloc
    AppError.create(
      message: 'Error in HomeBloc',
      type: ErrorType.unknown,
      originalError: error,
      stackTrace: stackTrace,
    );
    emit(HomeError(message: error.toString()));
  }
}
