import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/colors.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ContactUs extends StatefulWidget {

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final Razorpay _razorPay = Razorpay();



  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("PAYMENT SUCCESS: ${response}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("PAYMENT FAILED: ${response}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print("EXTERNAL WALLET: ${response}");
  }

  void initiatePayment({required double amount, required BuildContext context}) {

    try {
      var options = {
        'key': 'rzp_test_vP4RWtNGDpbee4', // todo store in remote config
        'amount': amount * 100, // convert paise to rupees
        'name': 'Acme Corp.',
        'description': 'Fine T-Shirt',
        'prefill': {
          'contact': '8888888888',
          'email': 'test@razorpay.com'
        }
      };
      _razorPay.open(options);
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("There was an error while initiating payment."),
      ));
    }
  }

  @override
  void initState() {
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorPay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);


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

    Widget _buildAmountDialog({required bool isDarkTheme}) {
      TextEditingController _amountController = TextEditingController();
      final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: isDarkTheme ? CustomColors.reportDialogBackgroundColor : CustomColors.lightModeBottomNavBarColor,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Utils.getCustomTextField(
                  hintText: "Enter amount",
                  controller: _amountController,
                  validator: (val) {
                    try {
                      double.parse(val!);
                      return null;
                    } on Exception catch (e) {
                      return "Please Enter only numbers";
                    }
                  }
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("AMOUNT: ${_amountController.text}");
                      initiatePayment(
                        amount: double.parse(_amountController.text),
                        context: context,
                      );
                    }
                  },
                  child: Text("DONATE", style: TextStyle(fontSize: 18),),
                ),
              ],
            ),
          ),
        ),
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
            SizedBox(height: 20,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )
              ),
              onPressed: () async {
                showDialog(context: context, builder: (context) {
                  return _buildAmountDialog(isDarkTheme: appThemeType.isDarkTheme());
                },);
              },
              child: Text("DONATE", style: TextStyle(fontSize: 18),),
            ),
          ],
        ),
      ),
    );
  }
}
