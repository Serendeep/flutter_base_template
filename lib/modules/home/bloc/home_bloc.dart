import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/core/base_bloc.dart';
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

      // Add your initialization logic here
      await Future.delayed(const Duration(seconds: 1)); // Simulated delay

      emit(const HomeLoaded(
        title: 'Welcome to Flutter Base Template',
        message: 'This is a sample home screen',
      ));
    } catch (e) {
      _logger.e('Error initializing home screen');
      _logger.e(e);
      emit(const HomeError(message: 'Failed to initialize home screen'));
    }
  }

  Future<void> _onLoadData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      _logger.i('Loading home data');
      emit(const HomeLoading());

      // Add your data loading logic here
      await Future.delayed(const Duration(seconds: 1)); // Simulated delay

      emit(const HomeLoaded(
        title: 'Data Loaded',
        message: 'Successfully loaded home screen data',
      ));
    } catch (e) {
      _logger.e('Error loading home data');
      _logger.e(e);
      emit(const HomeError(message: 'Failed to load home data'));
    }
  }

  Future<void> _onRefresh(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      _logger.i('Refreshing home data');
      final currentState = state;

      if (currentState is HomeLoaded) {
        emit(const HomeLoading(isRefreshing: true));

        // Add your refresh logic here
        await Future.delayed(const Duration(seconds: 1)); // Simulated delay

        emit(HomeLoaded(
          title: 'Data Refreshed',
          message: 'Successfully refreshed home screen data',
          lastRefreshed: DateTime.now(),
        ));
      }
    } catch (e) {
      _logger.e('Error refreshing home data');
      _logger.e(e);
      emit(const HomeError(message: 'Failed to refresh home data'));
    }
  }

  @override
  Future<void> handleEvent(HomeEvent event, Emitter<HomeState> emit) {
    // TODO: implement handleEvent
    throw UnimplementedError();
  }
}
