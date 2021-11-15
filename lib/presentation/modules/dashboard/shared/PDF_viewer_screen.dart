import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/checkbox_model.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:provider/provider.dart';

class PDFViewerScreen<ParameterType> extends StatefulWidget {
  final String screenLabel;
  final ParameterType parameter;
  final bool isShowBottomSheet;

  PDFViewerScreen({required this.screenLabel, required this.parameter, this.isShowBottomSheet = true});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {

  String pdfPath = "assets/pdfs/Javanotes.pdf";
  String pdfOnlinePath = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";

  bool _isLoading = true;
  late PDFDocument document;

  late List<CheckBoxModel> reportReasons;

  Widget getPostReportButton({required Function() onPressed, required bool isDarkTheme}) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
          )),
          backgroundColor: MaterialStateProperty.all(
            isDarkTheme ? CustomColors.reportButtonColor : CustomColors.lightModeRatingBackgroundColor
          ),
        ),
        onPressed: onPressed,
        child: Text("Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
      ),
    );
  }

  Widget getDownloadPostButton({required Function() onPressed}) {
    return SizedBox(
      height: 60,
      width: 100,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
          backgroundColor: MaterialStateProperty.all(CustomColors.downloadButtonColor),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(DefaultAssets.postDownloadIcon, color: CustomColors.bottomNavBarSelectedIconColor, scale: 0.8,),
            Text("Download", style: TextStyle(fontSize: 12),),
          ],
        ),
      ),
    );
  }

  Widget customPDFBottomNavBuilder(context, page, totalPages, jumpToPage, animateToPage) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.first_page, color: Colors.white,),
          onPressed: () {
            jumpToPage(page: 0);
          },
        ),
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            animateToPage(page: page - 2);
          },
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward, color: Colors.white,),
          onPressed: () {
            animateToPage(page: page);
          },
        ),
        IconButton(
          icon: Icon(Icons.last_page, color: Colors.white,),
          onPressed: () {
            jumpToPage(page: totalPages - 1);
          },
        ),
      ],
    );
  }

  Future loadDocumentFromAssetPath({required String assetPath}) async {
    setState(() => _isLoading = true);
    document = await PDFDocument.fromAsset(assetPath);
    setState(() => _isLoading = false);
    return;
  }

  void loadDocumentFromURL({required pdfURL}) async {
    setState(() => _isLoading = true);
    document = await PDFDocument.fromURL(pdfURL);
    setState(() => _isLoading = false);
  }

  void loadDocumentFromFile() {
    // File file  = File('...');
    // PDFDocument doc = await PDFDocument.fromFile(file);
  }

  Widget getUploadedByColumn({required String uploadedBy}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Uploaded By", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: 10,),
        Row(
          children: [
            CircleAvatar(
              child: FlutterLogo(),
              radius: 20,
            ),
            SizedBox(width: 10,),
            Text(uploadedBy, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildReportDialog({required bool isDarkTheme}) {
    return StatefulBuilder(
      builder: (context, setState) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: isDarkTheme ? CustomColors.reportDialogBackgroundColor : CustomColors.lightModeBottomNavBarColor,
        child: Container(
          // height: 400,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15,),
                Text("Report Content", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Color(0xff373F41), fontStyle: FontStyle.italic),),
                SizedBox(height: 10,),
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: reportReasons.length,
                    itemBuilder: (context, index) => CheckboxListTile(
                        tristate: false,
                        checkColor: Colors.white,
                        activeColor: Color(0xff3C64B1),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (val) { setState(() {
                          reportReasons[index].isChecked = !reportReasons[index].isChecked;
                        }); },
                        value: reportReasons[index].isChecked,
                        title: Text(reportReasons[index].label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),)
                    ),

                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.black26),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                          backgroundColor: MaterialStateProperty.all(CustomColors.lightModeBottomNavBarColor)
                      ),
                      child: Text("Cancel", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),),
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.black26),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                          backgroundColor: MaterialStateProperty.all(CustomColors.bottomNavBarColor)
                      ),
                      child: Text("Report", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),),
                    ),
                  ],
                ),
              ]
          ),
        ),
      ),
    );
  }

  Widget _buildBottomModel({required bool isDarkTheme}) {

    double ratingHeight = 30;
    double ratingBorderRadius = 20;
    double ratingWidth = 100;
    double ratingRightPosition = 10;
    
    if (widget.parameter.runtimeType == PDFScreenSimpleBottomSheet) {
      double modelHeight = 300;
      PDFScreenSimpleBottomSheet parameter = widget.parameter;
      return Stack(
        children: [
          Container(
              margin: EdgeInsets.only(top: ratingHeight),
              decoration: BoxDecoration(
                  color: isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              ),
              height: modelHeight,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(parameter.title!, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Variant ${parameter.nVariant}", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic)),
                            getDownloadPostButton(onPressed: () {}),
                          ],
                        ),
                        SizedBox(height: 15,),
                        getUploadedByColumn(uploadedBy: parameter.uploadedBy!),
                      ],
                    ),
                  ),
                  Spacer(),
                  getPostReportButton(
                    isDarkTheme: isDarkTheme,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => _buildReportDialog(isDarkTheme: isDarkTheme),
                      );
                    }
                  ),
                ],
              )
          ),
        ],
      );
    } else if (widget.parameter.runtimeType == PDFScreenSyllabusCopy) {
      double modelHeight = 340;
      PDFScreenSyllabusCopy parameter = widget.parameter;

      List<Widget> gridChildren = List.generate(parameter.totalVariants, (index) => ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            isDarkTheme ? CustomColors.ratingBackgroundColor : CustomColors.lightModeRatingBackgroundColor,
          ),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Colors.white38),
          ))
        ),
        child: Text("Variant ${index + 1}"),
      ));
      if (parameter.totalVariants < 2) {
        gridChildren.add(getAddPostContainer(
          isDarkTheme: isDarkTheme,
          label: "Add Syllabus Copy",
          onPressed: () {},
          context: context,
        ));
      }
      return Stack(
        children: [
          Container(
              margin: EdgeInsets.only(top: ratingHeight),
              decoration: BoxDecoration(
                color: isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              ),
              height: modelHeight,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Variant ${parameter.nVariant}", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic)),
                            getDownloadPostButton(onPressed: () {}),
                          ],
                        ),
                        SizedBox(height: 15,),
                        getUploadedByColumn(uploadedBy: parameter.uploadedBy!),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),


                  GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    crossAxisSpacing: 10,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    physics: NeverScrollableScrollPhysics(),
                    childAspectRatio: 18/7,
                    children: gridChildren,
                  ),


                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: children,
                  // ),
                  Spacer(),
                  getPostReportButton(
                    isDarkTheme: isDarkTheme,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => _buildReportDialog(isDarkTheme: isDarkTheme),
                      );
                    }
                  ),
                ],
              )
          ),
        ],
      );
    } else {
      PDFScreenNotesBottomSheet parameter = widget.parameter;
      return Stack(
        children: [
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.ratingBackgroundColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(ratingBorderRadius), topRight: Radius.circular(ratingBorderRadius)),
              ),
              height: ratingHeight,
              width: ratingWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(parameter.rating.toString(), style: TextStyle(fontWeight: FontWeight.w600),),
                  SizedBox(width: 5,),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  ),
                ],
              ),
            ),
            right: ratingRightPosition,
          ),
          Container(
              padding: EdgeInsets.only(top: 10,),
              margin: EdgeInsets.only(top: ratingHeight),
              decoration: BoxDecoration(
                  color: isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20))
              ),
              // height: modelHeight,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text(parameter.title!, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              getUploadedByColumn(uploadedBy: parameter.uploadedBy!),
                              getDownloadPostButton(onPressed: () {}),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          SizedBox(height: 10,),
                          Text(parameter.description!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 20,),
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text("Rate this Post", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                                SizedBox(height: 15,),
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  glow: false,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                SizedBox(height: 15,),
                              ],
                            )
                          ),

                        ],
                      ),
                    ),
                    getPostReportButton(
                      isDarkTheme: isDarkTheme,
                      onPressed: () {
                        showDialog(
                          context: context,
                            builder: (context) => _buildReportDialog(isDarkTheme: isDarkTheme),
                        );
                      }
                    ),
                  ],
                ),
              )
          ),
        ],
      );
    }
  }

  void _showCustomBottomSheet({required bool isDarkTheme}) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return _buildBottomModel(isDarkTheme: isDarkTheme);
      },
    );
  }

  @override
  void initState() {

    if (widget.isShowBottomSheet) {
      SchedulerBinding.instance!.addPostFrameCallback((_) async {
        final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

        await loadDocumentFromAssetPath(assetPath: pdfPath);
        _showCustomBottomSheet(isDarkTheme: appThemeType.isDarkTheme());
      });
    }
    reportReasons = AppConstants.reportReasons.map((e) => CheckBoxModel(
      label: e,
      isChecked: false,
    )).toList();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.screenLabel),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ElevatedButton(
              onPressed: () {
                _showCustomBottomSheet(isDarkTheme: appThemeType.isDarkTheme());
              },
              child: Text("Details", style: TextStyle(fontSize: 16,),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
              document: document,
              zoomSteps: 1,

              showNavigation: false,
              // navigationBuilder: customPDFBottomNavBuilder,


              showPicker: false,
              pickerButtonColor: Colors.black,
              pickerIconColor: Colors.red,

              enableSwipeNavigation: true,

              progressIndicator: Text("Loading", style: TextStyle(fontSize: 20),),


              indicatorPosition: IndicatorPosition.topLeft,
              indicatorBackground: Colors.black,
              indicatorText: Colors.white,
              // showIndicator: false,

              lazyLoad: true,

              scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
