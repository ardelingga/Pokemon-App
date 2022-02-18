import 'package:dio/dio.dart';

String dioErrorMessage(DioError e) {
  String? msg;

  if (e.type == DioErrorType.response) {
    int statusCode = e.response!.statusCode!;
    if (statusCode == 404) {
      msg = "Not Found";
    } else if (statusCode == 500) {
      msg = "Internal Server Error";
    } else {
      msg = e.message.toString();
    }
  } else if (e.type == DioErrorType.connectTimeout) {
    msg = "Please check your internet connection and try again.";
  } else if (e.type == DioErrorType.cancel) {
    msg = "Cancel";
  }

  return msg ?? "";
}
