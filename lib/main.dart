import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RazorPay Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RazorPay Demo",
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter Amount',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {
                openCheckout();
              },
              child: Text(
                "Pay",
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _paymentSuccessHandler);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _paymentErrorHandler);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _externalWalletHandler);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_m7Lqgq5bFCpatf',
      'amount': '2000',
      'name': 'Harsh Corp.',
      'description': 'Hardware',
      'prefill': {'contact': '9191919191', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['phonepe']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _paymentSuccessHandler(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Success!" + response.paymentId);
  }

  void _paymentErrorHandler(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Failure." + response.code.toString() + "-" + response.message);
  }

  void _externalWalletHandler(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External Wallet" + response.walletName);
  }
}
