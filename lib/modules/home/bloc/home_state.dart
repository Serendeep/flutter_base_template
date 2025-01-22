part of 'home_bloc.dart';

abstract class HomeState extends BaseState {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  final bool isRefreshing;

  const HomeLoading({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

class HomeLoaded extends HomeState {
  final String title;
  final String message;
  final DateTime? lastRefreshed;
  final Map<String, dynamic>? data;

  const HomeLoaded({
    required this.title,
    required this.message,
    this.lastRefreshed,
    this.data,
  });

  @override
  List<Object?> get props => [title, message, lastRefreshed, data];

  HomeLoaded copyWith({
    String? title,
    String? message,
    DateTime? lastRefreshed,
    Map<String, dynamic>? data,
  }) {
    return HomeLoaded(
      title: title ?? this.title,
      message: message ?? this.message,
      lastRefreshed: lastRefreshed ?? this.lastRefreshed,
      data: data ?? this.data,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
