import 'dart:io';

import 'package:dio/dio.dart';
import 'package:maidc_seller/data/datasource/remote/dio/dio_client.dart';
import 'package:maidc_seller/utill/app_constants.dart';

import '../datasource/remote/exception/api_error_handler.dart';
import '../model/response/base/api_response.dart';

class ArticleRepo {
  final DioClient? dioClient;
  ArticleRepo({required this.dioClient});

  Future<ApiResponse> getArticleList() async {
    try {
      final response = await dioClient!.get(
        AppConstants.articleList,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  //Add Article
  Future<ApiResponse> addArticle(
      String title, String details, File? image) async {
    try {
      FormData formData = FormData.fromMap({
        'title': title,
        'details': details,
        'image': image != null
            ? await MultipartFile.fromFile(image.path,
                filename: image.path.split('/').last)
            : null,
      });
      final response =
          await dioClient!.post(AppConstants.addArticle, data: formData);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
