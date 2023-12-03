import 'package:fluttertoast/fluttertoast.dart';

showSnackBar(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      // gravity: ToastGravity.CENTER,
      // timeInSecForIosWeb: 1,
      // backgroundColor: Colors.red,
      // textColor: Colors.white,
      fontSize: 20.0);
}
