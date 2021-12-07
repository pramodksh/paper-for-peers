import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/colors.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class ContactUs extends StatefulWidget {

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  final String akashEmail = "akash.punagin@gmail.com";
  final String pramodEmail = "pramodkumarsh3@gmail.com";

  Widget getEmailRow({required String email}) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.email, size: 30,),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: email));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email copied"), duration: Duration(milliseconds: 300),));
          },
        ),
        SizedBox(width: 20,),
        Text(email, style: TextStyle(fontSize: 18),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

    return Scaffold(
      appBar: AppBar(title: Text("Contact Us",),),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Align(alignment: Alignment.centerLeft, child: Text("Email Us:", style: TextStyle(fontSize: 25),)),
            SizedBox(height: 10,),
            getEmailRow(email: akashEmail),
            SizedBox(height: 20,),
            getEmailRow(email: pramodEmail),
          ],
        ),
      ),
    );
  }
}
