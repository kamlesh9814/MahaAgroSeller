import 'package:shared_preferences/shared_preferences.dart';
import 'package:maidc_seller/data/datasource/remote/dio/dio_client.dart';
import 'package:maidc_seller/data/datasource/remote/exception/api_error_handler.dart';
import 'package:maidc_seller/data/model/body/seller_body.dart';
import 'package:maidc_seller/data/model/response/base/api_response.dart';
import 'package:maidc_seller/data/model/response/seller_info.dart';
import 'package:maidc_seller/utill/app_constants.dart';
import 'package:http/http.dart' as http;

class BankInfoRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  BankInfoRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getBankList() async {
    try {
      final response = await dioClient!.get(AppConstants.sellerUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> chartFilterData(String? type) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.chartFilterData}$type');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> updateBank(
      SellerModel userInfoModel, SellerBody seller, String token) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.sellerAndBankUpdate}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put',
      'bank_name': userInfoModel.bankName!,
      'branch': userInfoModel.branch!,
      'holder_name': userInfoModel.holderName!,
      'account_no': userInfoModel.accountNo!,
      'f_name': seller.fName!,
      'l_name': seller.lName!,
      'phone': userInfoModel.phone!
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  String getBankToken() {
    return sharedPreferences!.getString(AppConstants.token) ?? "";
  }
}
