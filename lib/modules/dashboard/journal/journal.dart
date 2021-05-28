import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';

class Journal extends StatefulWidget {
  final bool isDarkTheme;

  Journal({this.isDarkTheme});

  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {

  DateFormat dateFormat = DateFormat("dd MMMM yyyy");

  void onAddJournalPressed(){

  }

  Widget getJournalVariantDetailsTile({@required int nVariant, @required DateTime uploadedOn, @required String uploadedBy}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: widget.isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Variant $nVariant", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),),
              Text(dateFormat.format(uploadedOn), style: TextStyle(fontSize: 14),),
            ],
          ),
          Row(
            children: [
              CircleAvatar(
                child: FlutterLogo(),
                radius: 15,
              ),
              SizedBox(width: 10,),
              Text(uploadedBy, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget getJournalTile({@required String subject, @required int nVariants}) {

    assert(nVariants <= 2);

    List<Widget> gridChildren = List.generate(nVariants, (index) => getJournalVariantDetailsTile(
        nVariant: index + 1,
        uploadedOn: DateTime.now(),
        uploadedBy: "John Doe"
    ));

    if (nVariants < 2) {
      gridChildren.add(getAddPostContainer(
        context: context,
        onPressed: onAddJournalPressed,
        label: "Add Journal",
        isExpanded: true,
      ));
    }


    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subject, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),),
          SizedBox(height: 20,),
          GridView.count(
            crossAxisSpacing: 10,
            shrinkWrap: true,
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 16/7,
            children: gridChildren,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              getCourseText(course: "BCA", semester: 6),
              SizedBox(height: 20,),
              getJournalTile(subject: "C++", nVariants: 1),
              SizedBox(height: 20,),
              getJournalTile(subject: "Java", nVariants: 2),
              SizedBox(height: 20,),
              getJournalTile(subject: "Java", nVariants: 0),
            ],
          ),
        ),
      ),
    );
  }
}
