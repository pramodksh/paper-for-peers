import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/models/notification_model.dart';
import 'package:papers_for_peers/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/services/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_scraper/web_scraper.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  WebScraper webScraper = WebScraper();
  List<NotificationModel> notifications = [];
  bool _isLoading = false;
  DateFormat dateFormat = DateFormat("dd MMMM yyyy");

  void setNotificationsFromWeb() async {
    print("Loading URL");
    setState(() { _isLoading = true; });
    try {
      bool isLoaded = await webScraper.loadFullURL(AppConstants.KUDNotificationsURL);
      if (isLoaded) {
        print("Web page loaded");
        List<Map<String, dynamic>> datesMap = webScraper.getElement('td > table.tblContent > tbody > tr > td:nth-child(2)', ['style']);
        List<Map<String, dynamic>> notificationsMap = webScraper.getElement('td > table.tblContent > tbody > tr > td:nth-child(1)', ['href']);
        List<Map<String, dynamic>> linksMap = webScraper.getElement('td > table.tblContent > tbody > tr > td:nth-child(3) > a', ['href']);

        print("${datesMap.length} || ${notificationsMap.length} || ${linksMap.length}");

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
      } else {
        print("NOT LOADED");
      }
      print("DONE");
    } catch (e) {
      print("ERROR: ${e}");
    }
    setState(() { _isLoading = false; });
  }

  Widget getNotificationTile({
    @required NotificationModel notificationModel,
    @required bool isDarkTheme,
    @required int index,
  }) {
    double dateHeight = 30;
    double dateWidth = 150;
    double dateBorderRadius = 20;
    // foo
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              padding: EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: isDarkTheme ? CustomColors.ratingBackgroundColor : CustomColors.lightModeRatingBackgroundColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(dateBorderRadius), topRight: Radius.circular(dateBorderRadius)),
              ),
              height: dateHeight,
              width: dateWidth,
              child: Center(child: Text(dateFormat.format(notifications[index].dateOfNotification))),
            ),
            right: 15,
          ),
          Container(
            margin: EdgeInsets.only(top: dateHeight),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ListTile(
                tileColor: isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                onTap: () async {
                  var url = AppConstants.KUDBaseURL + notifications[index].link;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    showAlertDialog(context: context, text: "Couldn't open url - $url");
                  }
                },
                leading: Text((index + 1).toString()),
                minLeadingWidth: 10,
                title: Text(notifications[index].notification, style: TextStyle(fontSize: 18),),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    setNotificationsFromWeb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLoading ? "KUD Notifications" : "KUD Notifications (${notifications.length})"
        ),
      ),
      body: _isLoading ? LoadingScreen(
        loadingText: "Loading URL - ${AppConstants.KUDNotificationsURL}",
      ) : Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) => getNotificationTile(
            index: index,
            notificationModel: notifications[index],
            isDarkTheme: themeChange.isDarkTheme,
          ),
        ),
      ),
    );
  }
}
