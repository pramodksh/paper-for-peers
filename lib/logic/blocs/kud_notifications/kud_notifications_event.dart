part of 'kud_notifications_bloc.dart';

abstract class KudNotificationsEvent extends Equatable {
  const KudNotificationsEvent();
}

class KudNotificationsFetch extends KudNotificationsEvent {
  @override
  List<Object?> get props => [];
}