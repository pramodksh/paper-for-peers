part of 'kud_notifications_bloc.dart';

abstract class KudNotificationsEvent extends Equatable {
  const KudNotificationsEvent();
}

class KudNotificationsFetched extends KudNotificationsEvent {
  @override
  List<Object?> get props => [];
}