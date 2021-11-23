import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/data/models/notification_model.dart';
import 'package:web_scraper/web_scraper.dart';

part 'kud_notifications_event.dart';
part 'kud_notifications_state.dart';

class KudNotificationsBloc extends Bloc<KudNotificationsEvent, KudNotificationsState> {

  Future<List<NotificationModel>?> getKudNotificationsFromWeb() async {

    WebScraper webScraper = WebScraper();

    print("Loading URL");
    try {
      bool isLoaded = await webScraper.loadFullURL(AppConstants.KUDNotificationsURL);
      if (isLoaded) {
        print("Web page loaded");
        List<Map<String, dynamic>> datesMap = webScraper.getElement('td > table.tblContent > tbody > tr > td:nth-child(2)', ['style']);
        List<Map<String, dynamic>> notificationsMap = webScraper.getElement('td > table.tblContent > tbody > tr > td:nth-child(1)', ['href']);
        List<Map<String, dynamic>> linksMap = webScraper.getElement('td > table.tblContent > tbody > tr > td:nth-child(3) > a', ['href']);

        print("${datesMap.length} || ${notificationsMap.length} || ${linksMap.length}");

        List<NotificationModel> notifications = [];

        for (int index = 0; index < datesMap.length; index++) {
          List splitDate = datesMap[index]['title'].toString().split("/");
          int year = int.parse(splitDate[2]);
          int month = int.parse(splitDate[1]);
          int date = int.parse(splitDate[0]);
          DateTime dateOfNotification = DateTime(year, month = month, date = date);
          notifications.add(NotificationModel(
            notification: notificationsMap[index]['title'],
            dateOfNotification: dateOfNotification,
            link: linksMap[index]['attributes']['href'],
          ));
        }

        return notifications;

      } else {
        print("NOT LOADED");
        return null;
      }
    } catch (e) {
      print("ERROR: $e");
      return null;
    }
  }

  KudNotificationsBloc() : super(KudNotificationsInitial()) {
    on<KudNotificationsFetch>((event, emit) async {
      emit(KudNotificationsFetchLoading());
      List<NotificationModel>? notifications =  await getKudNotificationsFromWeb();

      if (notifications == null) {
        emit(KudNotificationsFetchError(errorMessage: "There was some error while fetching notifications from the url"));
      } else {
        emit(KudNotificationsFetchLoaded(notifications: notifications));
      }
    });
  }
}
