import 'package:dio/dio.dart';
import 'package:maidc_seller/data/datasource/remote/dio/dio_client.dart';
import 'package:maidc_seller/data/datasource/remote/exception/api_error_handler.dart';
import 'package:maidc_seller/data/model/response/base/api_response.dart';
import 'package:maidc_seller/utill/app_constants.dart';

class RefundRepo {
  final DioClient? dioClient;
  RefundRepo({required this.dioClient});

  Future<ApiResponse> getRefundList() async {
    try {
      final response = await dioClient!.get(AppConstants.refundListUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRefundReqDetails(int? orderDetailsId) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.refundItemDetails}?order_details_id=$orderDetailsId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> refundStatus(
      int? refundId, String status, String note) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.refundReqStatusUpdate,
        data: {
          'refund_status': status,
          'refund_request_id': refundId,
          'note': note
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRefundStatusList(String type) async {
    try {
      List<String> refundTypeList = [];

      refundTypeList = [
        'Select Refund Status',
        AppConstants.approved,
        AppConstants.rejected,
      ];
      Response response = Response(
          requestOptions: RequestOptions(path: ''),
          data: refundTypeList,
          statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
