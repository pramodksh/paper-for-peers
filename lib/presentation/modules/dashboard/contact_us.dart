import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // todo move outside build
    final String akashEmail = "akash.punagin@gmail.com";
    final String pramodEmail = "pramodKumar@gmail.com";

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
