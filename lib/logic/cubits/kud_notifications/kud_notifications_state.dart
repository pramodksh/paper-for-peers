part of 'kud_notifications_cubit.dart';

@immutable
abstract class KudNotificationsState extends Equatable {}

class KudNotificationsInitial extends KudNotificationsState {

  @override
  List<Object?> get props => [];

}

class KudNotificationsFetchLoading extends KudNotificationsState {

  @override
  List<Object?> get props => [];

}

class KudNotificationsFetchLoaded extends KudNotificationsState {

  final List<NotificationModel> notifications;

  @override
  List<Object?> get props => [notifications];

  KudNotificationsFetchLoaded({
    required this.notifications,
  });
}

class KudNotificationsFetchError extends KudNotificationsState {
  final String errorMessage;

  KudNotificationsFetchError({
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [errorMessage];
}
