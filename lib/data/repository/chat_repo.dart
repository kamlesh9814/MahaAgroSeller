import 'package:flutter/foundation.dart';
import 'package:maidc_seller/data/datasource/remote/dio/dio_client.dart';
import 'package:maidc_seller/data/datasource/remote/exception/api_error_handler.dart';
import 'package:maidc_seller/data/model/body/message_body.dart';
import 'package:maidc_seller/data/model/response/base/api_response.dart';
import 'package:maidc_seller/utill/app_constants.dart';

class ChatRepo {
  final DioClient? dioClient;
  ChatRepo({required this.dioClient});

  Future<ApiResponse> getChatList(String type, int offset) async {
    try {
      final response = await dioClient!
          .get('${AppConstants.cartUri}$type?limit=30&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> searchChat(String type, String search) async {
    try {
      final response = await dioClient!
          .get('${AppConstants.chatSearchUri}$type?search=$search');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getMessageList(String type, int offset, int? id) async {
    try {
      final response = await dioClient!
          .get('${AppConstants.messageUri}$type/$id?limit=30&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> sendMessage(String type, MessageBody messageBody) async {
    if (kDebugMode) {
      print('==body===>${messageBody.toJson()}');
    }
    try {
      final response = await dioClient!.post(
          '${AppConstants.sendMessageUri}$type',
          data: messageBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
