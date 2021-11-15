
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/notification_model.dart';
import 'package:papers_for_peers/logic/blocs/kud_notifications/kud_notifications_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Notifications extends StatelessWidget {
  final DateFormat dateFormat = DateFormat("dd MMMM yyyy");

  Widget getNotificationTile({
    required NotificationModel notificationModel,
    required bool isDarkTheme,
    required int index,
    required BuildContext context,
  }) {
    final double dateHeight = 30;
    final double dateWidth = 150;
    final double dateBorderRadius = 15;

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
              child: Center(child: Text(dateFormat.format(notificationModel.dateOfNotification))),
            ),
            right: 15,
          ),
          Container(
            margin: EdgeInsets.only(top: dateHeight),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
              tileColor: isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              onTap: () async {
                var url = AppConstants.KUDBaseURL + notificationModel.link!;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  showAlertDialog(context: context, text: "Couldn't open url - $url");
                }
              },
              leading: Text((index + 1).toString()),
              minLeadingWidth: 10,
              title: Text(notificationModel.notification!, style: TextStyle(fontSize: 18),),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _getAppBar({required BuildContext context}) {
    KudNotificationsState kudNotificationsState = context.select((KudNotificationsBloc bloc) => bloc.state);

    return AppBar(
      title: Text(
        kudNotificationsState is KudNotificationsFetchLoaded ?
        "KUD Notifications (${kudNotificationsState.notifications.length})"
            : "KUD Notifications",
      ),
    );
  }

  Widget getBodyTextWidget({
    required String label,
    required double appBarHeight,
    required BuildContext context,
  }) {
    return ListView(
      children: [
        Container(
            height: MediaQuery.of(context).size.height - appBarHeight,
            child: Center(child: Text(label, style: TextStyle(fontSize: 20),))
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    AppBar _appBar = _getAppBar(context: context);

    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () {
        context.read<KudNotificationsBloc>().add(KudNotificationsFetched());
        return Future.value(true);
      },
      child: Scaffold(
        appBar: _appBar,
        body: Builder(
          builder: (context) {
            KudNotificationsState kudNotificationsState = context.watch<KudNotificationsBloc>().state;
            AppThemeState appThemeState = context.watch<AppThemeCubit>().state;

            if (kudNotificationsState is KudNotificationsFetchLoading) {
              return LoadingScreen(loadingText: "Loading URL - ${AppConstants.KUDNotificationsURL}",);
            } else if (kudNotificationsState is KudNotificationsInitial) {
              return getBodyTextWidget(label: "Pull down to load notifications", appBarHeight: _appBar.preferredSize.height, context: context);
            } else if (kudNotificationsState is KudNotificationsFetchError) {
              return getBodyTextWidget(label: "Error while loading Kud Notifications", appBarHeight: _appBar.preferredSize.height, context: context);
            } else if (kudNotificationsState is KudNotificationsFetchLoaded){
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: kudNotificationsState.notifications.length,
                itemBuilder: (context, index) => getNotificationTile(
                  index: index,
                  notificationModel: kudNotificationsState.notifications[index],
                  isDarkTheme: appThemeState.appThemeType.isDarkTheme(),
                  context: context,
                ),
              );
            } else {
              return CircularProgressIndicator.adaptive();
            }
          },
        ),
      ),
    );
  }
}
