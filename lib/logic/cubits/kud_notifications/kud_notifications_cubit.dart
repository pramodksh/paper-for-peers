import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:papers_for_peers/data/models/notification_model.dart';

part 'kud_notifications_state.dart';

class KudNotificationsCubit extends Cubit<KudNotificationsState> {
  KudNotificationsCubit() : super(KudNotificationsInitial());
}
