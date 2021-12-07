part of 'kud_notifications_bloc.dart';

abstract class KudNotificationsState extends Equatable {
  const KudNotificationsState();
}

class KudNotificationsInitial extends KudNotificationsState {
  @override
  List<Object> get props => [];
}

class KudNotificationsFetchLoading extends KudNotificationsState {
  @override
  List<Object> get props => [];
}

class KudNotificationsFetchLoaded extends KudNotificationsState {

  final List<NotificationModel> notifications;


  @override
  List<Object> get props => [];

  KudNotificationsFetchLoaded({
    required this.notifications,
  });
}

class KudNotificationsFetchError extends KudNotificationsState {

  final String errorMessage;

  @override
  List<Object> get props => [];

  const KudNotificationsFetchError({
    required this.errorMessage,
  });
}