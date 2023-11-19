import 'package:fluttertoast/fluttertoast.dart';

// showSnackBar(BuildContext context, String message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Center(
//         child: Text(message),
//       ),
//       behavior: SnackBarBehavior.floating,
//       margin: const EdgeInsets.all(30),
//       shape: const StadiumBorder(),
//       duration: const Duration(milliseconds: 2000),
//     ),
//   );
// }

showSnackBar(String message) {
  Fluttertoast.showToast(
      msg: message,
      // toastLength: Toast.LENGTH_SHORT,
      // gravity: ToastGravity.CENTER,
      // timeInSecForIosWeb: 1,
      // backgroundColor: Colors.red,
      // textColor: Colors.white,
      fontSize: 20.0);
}
