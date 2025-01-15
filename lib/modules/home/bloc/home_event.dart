part of 'home_bloc.dart';

abstract class HomeEvent extends BaseEvent {
  const HomeEvent();
}

class InitializeHomeEvent extends HomeEvent {
  const InitializeHomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeDataEvent extends HomeEvent {
  final bool forceRefresh;

  const LoadHomeDataEvent({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class RefreshHomeDataEvent extends HomeEvent {
  const RefreshHomeDataEvent();

  @override
  List<Object?> get props => [];
}
