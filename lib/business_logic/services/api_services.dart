import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_app/business_logic/config/config.dart';
import 'package:pokemon_app/business_logic/models/response_model.dart';
import 'package:pokemon_app/business_logic/utils/dio_error_message_utils.dart';

ApiService apiService = ApiService();

class ApiService {
  Dio? dio;
  CancelToken cancelToken = CancelToken();

  Future init() async {
    var options = BaseOptions(
        baseUrl: Config.baseUrl,
        contentType: Headers.formUrlEncodedContentType,
        connectTimeout: 5000,
        receiveTimeout: 4000);

    dio = Dio(options);
    // dio!.interceptors.add(PrettyDioLogger());
  }

  Future getRequest(String url, {params}) async {
    try {
      Response response = await dio!.get(
        url,
        queryParameters: params,
        cancelToken: cancelToken,
      );

      return ResponseModel(
        status: true,
        data: response.data,
      );
    } on DioError catch (e) {
      debugPrint("ERROR => " + e.message.toString());
      return ResponseModel(
        status: false,
        message: dioErrorMessage(e),
      );
    }
  }
}
