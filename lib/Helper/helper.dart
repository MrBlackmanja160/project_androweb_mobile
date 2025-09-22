import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:kalbemd/Helper/global.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:kalbemd/Theme/colors.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
double statusBarHeight(BuildContext context) =>
    MediaQuery.of(context).padding.top;
double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;

class ModelMenu {
  String? image;
  String? label;
  VoidCallback? ontap;

  ModelMenu({this.label, this.ontap, this.image});
}

class Helper {
  static TextFormField createTextField(
      TextEditingController controller, String label, IconData icon,
      {obscureText = false, obscureIcon, double borderRadius = 360}) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      style: const TextStyle(color: Colors.black54),
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        counterText: "",
        fillColor: warnautama.withOpacity(0.2),
        // hintText: label,
        label: Text(
          label,
          style: const TextStyle(color: Colors.black54),
        ),
        // labelText: label,
        labelStyle: const TextStyle(
            color: Colors.black87, fontFamily: "Poppins-Regular"),
        // contentPadding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
        border: InputBorder.none,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: warnautama.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(borderRadius)),
        prefixIcon: Icon(
          icon,
          size: 18,
          color: warnautama,
        ),
        suffixIcon: obscureIcon,
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: warnautama, width: 1),
            borderRadius: BorderRadius.circular(borderRadius)),
      ),
    );
  }

  static TextFormField formdate(
      TextEditingController controller, String label, IconData icon,
      {obscureText = false, obscureIcon, double borderRadius = 360}) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      style: const TextStyle(color: Colors.black54),
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
        counterText: "",
        fillColor: warnautama.withOpacity(0.1),
        hintText: label,
        // labelText: label,
        labelStyle: const TextStyle(
            color: Colors.black87, fontFamily: "Poppins-Regular"),
        // contentPadding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
        border: InputBorder.none,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: warnautama.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(borderRadius)),
        prefixIcon: Icon(
          icon,
          size: 18,
          color: warnautama,
        ),
        suffixIcon: obscureIcon,
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: warnautama, width: 1),
            borderRadius: BorderRadius.circular(borderRadius)),
      ),
    );
  }

  static Widget createButton(String label, VoidCallback onPressed,
      {bool inverted = false, double minWidth = 100}) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(warnakedua),
            minimumSize: WidgetStateProperty.all(Size(minWidth, 60)),
            backgroundColor:
                WidgetStateProperty.all(inverted ? Colors.white : warnautama),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(360),
              side: BorderSide(color: warnautama, width: inverted ? 2 : 0),
            ))),
        child: Text(
          label,
          style: inverted
              ? const TextStyle(
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                )
              : const TextStyle(
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: textColorInvert,
                ),
        ));
  }

  static Widget checkinbutton(String label, Color color, VoidCallback onPressed,
      {bool inverted = false, double minWidth = 50}) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(warnakedua),
            minimumSize: WidgetStateProperty.all(Size(minWidth, 20)),
            backgroundColor:
                WidgetStateProperty.all(inverted ? warnakedua : warnakedua),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: BorderSide(color: color, width: inverted ? 2 : 0),
            ))),
        child: Text(
          label,
          style: inverted
              ? const TextStyle(
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                )
              : const TextStyle(
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: textColorInvert,
                ),
        ));
  }

  static Widget detailcheckin(
      String image, String title, String deskripsi, double iconsize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: iconsize,
          backgroundImage: AssetImage(image),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "Poppins-Bold",
                  color: Colors.black87),
            ),
            Text(
              deskripsi,
              style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins-Bold",
                  color: Colors.black54),
            )
          ],
        ),
      ],
    );
  }

  static Widget headerhome(String image, String title, String deskripsi) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xffFDCF09),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(image),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: "Poppins-BoldItalic",
                  fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              deskripsi,
              style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: "Poppins-BoldItalic",
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            )
          ],
        )
      ],
    );
  }

  static Widget menuhome(List<ModelMenu> menu) {
    final borderRadius = BorderRadius.circular(10);

    // ignore: sized_box_for_whitespace
    return Container(
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            for (var menuku in menu)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.grey[200],
                    borderRadius: borderRadius,
                    child: InkWell(
                      splashColor: Colors.white,
                      borderRadius: borderRadius,
                      onTap: menuku.ontap,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Image.asset(
                              menuku.image!,
                              height: 60,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              menuku.label!,
                              textAlign: TextAlign.center,
                              style: textStyleRegular,
                              maxFontSize: 16,
                            ),
                            // Text(
                            //   menuku.label!,
                            //   style: textStyleRegular,
                            //   textAlign: TextAlign.center,
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ));
  }

  static PreferredSizeWidget createAppBar({
    String? title,
    Widget? leading,
    List<Widget>? actions,
  }) {
    return AppBar(
      shadowColor: Colors.transparent,
      bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider()),
      leading: leading,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          title!,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      actions: actions,
    );
  }

  static Widget createIconButton(IconData? icon, VoidCallback? onPressed,
      {String? label = "",
      bool? inverted = false,
      double? minWidth = 100,
      double? minHeight = 50,
      double? borderRadius = 360,
      bool? disabled = false,
      color}) {
    var color0 = warnautama;
    if (color != null) {
      color0 = color;
    }
    var mainColor = disabled! ? colorDisabled : color0;

    return TextButton(
        onPressed: disabled ? () => {} : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: inverted! ? mainColor : Colors.white,
              size: 18,
            ),
            if (label != "")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  label!,
                  style: inverted ? textStyleBold : textStyleBoldInvert,
                ),
              )
          ],
        ),
        style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(
                !disabled ? warnakedua : colorDisabled),
            minimumSize: WidgetStateProperty.all(Size(minWidth!, minHeight!)),
            backgroundColor:
                WidgetStateProperty.all(inverted ? Colors.white : mainColor),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius!),
              side: BorderSide(color: mainColor, width: inverted ? 2 : 0),
            ))));
  }

  static String extractBodyFromHTML(String htmlString) {
    var reg = RegExp("<body>([\\s\\S.]*)<\\/body>", multiLine: true);
    var result = reg.stringMatch(htmlString);
    return result.toString();
  }

  static void sendHttpPostOld(
    String url, {
    Function? onStart,
    void Function(dynamic)? onFinish,
    Object? postData,
  }) async {
    try {
      log("Sending data to $url: \n $postData");

      // On start
      if (onStart != null) onStart();

      // Request API
      http.Response response = await http.post(Uri.parse(url), body: postData);
      log("Response from $url : \n${response.body}");
      // log("Response from $url");

      // onFinish
      if (onFinish != null) {
        onFinish(jsonDecode(response.body));
      }
    } on SocketException {
      log("No internet connection");
    } on HttpException {
      log("Couldn't connect to server");
    } on FormatException {
      log("Bad response format");
    } on http.ClientException {
      log("Client error");
    }
  }

  // ----------------
  // BOKI
  // ----------------

  static Future<HttpPostResponse> sendHttpPost(
    String url, {
    Object? postData,
  }) async {
    HttpPostResponse result = HttpPostResponse();
    try {
      log("Sending data to $url: \n $postData");
      // Request API
      http.Response response = await http.post(Uri.parse(url), body: postData);
      log("Response from $url : \n${response.body}");
      // log("Response from $url");
      result.responseBody = response.body;
      result.data = jsonDecode(response.body);
      result.success = true;
    } on SocketException {
      log("Tidak ada koneksi internet");
      result.error = "Tidak ada koneksi internet";
    } on HttpException {
      log("Tidak dapat terhubung ke server");
      result.error = "Tidak dapat terhubung ke server";
    } on FormatException {
      log("Terjadi kesalahan. Klik detail dan kirim ke admin");
      result.error = "Terjadi kesalahan. Klik detail dan kirim ke admin";
    } on http.ClientException {
      log("Kesalahan Client");
      result.error = "Kesalahan Client";
    } on TimeoutException {
      log("Tidak ada respon, coba lagi");
      result.error = "Tidak ada respon, coba lagi";
    }

    return result;
  }

  static Future<dynamic> getInfoLog(BuildContext context) async {
    var infoLog = {};

    // Post data
    String iduser = await Helper.getPrefs("iduser");

    // Request
    HttpPostResponse response = await Helper.sendHttpPost(
      urlInfoLog,
      postData: {
        "tokenaplikasi": tokenAplikasi,
        "iduser": iduser,
      },
    );

    // Success
    if (response.success) {
      infoLog = response.data;
    } else {
      Helper.showAlert(
        context: context,
        message: response.error,
        details: response.responseBody,
      );
    }

    return infoLog;
  }

  static void dumpPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var test = "PREFS DATA : \n";
    prefs.getKeys().forEach((element) {
      test += "$element : ${prefs.getString(element) ?? ""}\n";
    });
    log(test);
  }

  static Future<String> getPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  /// WARNING : make sure the widget is mounted before calling [showSnackBar]
  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.error,
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message),
      ),
      action: SnackBarAction(
        label: 'Tutup',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// WARNING : make sure the widget is mounted before calling [showAlert]
  static void showAlert({
    required BuildContext context,
    String? message,
    AlertType? type = AlertType.info,
    Function()? onClose,
    String? details,
  }) {
    Color iconColor;
    IconData? icon;
    switch (type) {
      case AlertType.info:
        icon = FontAwesomeIcons.infoCircle;
        iconColor = Theme.of(context).primaryColor;
        break;
      case AlertType.success:
        icon = FontAwesomeIcons.checkCircle;
        iconColor = Colors.green;
        break;
      case AlertType.error:
        icon = FontAwesomeIcons.exclamationTriangle;
        iconColor = Colors.red;
        break;
      default:
        icon = FontAwesomeIcons.infoCircle;
        iconColor = Theme.of(context).primaryColor;
        break;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                icon,
                color: iconColor,
                size: 64,
              ),
            ),
            Text(message ?? ""),
          ],
        ),
        actions: [
          if (details != null)
            OutlinedButton(
              child: const Text("Details"),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Scrollbar(
                    child: SingleChildScrollView(
                      child: Text(
                        details.replaceAll(
                            RegExp(r"<head>[.\s\S]*<\/head>"), ""),
                        style: textStyleSmall,
                      ),
                    ),
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: details));
                      },
                      child: const Text("Copy"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              ),
            ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    ).then((value) => onClose?.call());
  }

  static void showAlertPengembalian({
    required BuildContext context,
    String? message,
    AlertType? type = AlertType.info,
    Function()? onClose,
    String? details,
  }) {
    Color iconColor;
    IconData? icon;
    switch (type) {
      case AlertType.info:
        icon = FontAwesomeIcons.infoCircle;
        iconColor = Theme.of(context).primaryColor;
        break;
      case AlertType.success:
        icon = FontAwesomeIcons.checkCircle;
        iconColor = Colors.green;
        break;
      case AlertType.error:
        icon = FontAwesomeIcons.exclamationTriangle;
        iconColor = Colors.red;
        break;
      default:
        icon = FontAwesomeIcons.infoCircle;
        iconColor = Theme.of(context).primaryColor;
        break;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                icon,
                color: iconColor,
                size: 64,
              ),
            ),
            Text(message ?? ""),
          ],
        ),
        actions: [
          if (details != null)
            OutlinedButton(
              child: const Text("Details"),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Scrollbar(
                    child: SingleChildScrollView(
                      child: Text(
                        details.replaceAll(
                            RegExp(r"<head>[.\s\S]*<\/head>"), ""),
                        style: textStyleSmall,
                      ),
                    ),
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: details));
                      },
                      child: const Text("Copy"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              ),
            ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    ).then((value) => onClose?.call());
  }

  static String formatNumberThousandSeparator(double value) {
    var formatter = NumberFormat('#,###');
    return formatter.format(value).replaceAll(",", ".");
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenMaxSize(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return math.max(size.width, size.height);
  }
}

class HttpPostResponse {
  bool success;
  String error;
  dynamic data;
  String responseBody;

  HttpPostResponse({
    this.success = false,
    this.error = "",
    this.data,
    this.responseBody = "",
  });

  @override
  String toString() {
    String out = "";
    out += "success : $success\n";
    out += "error : $error\n";
    out += "data : $data\n";
    out += "responseBody : $responseBody\n";
    return out;
  }
}

enum AlertType { info, success, error }
