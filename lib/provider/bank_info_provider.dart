import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maidc_seller/data/model/body/seller_body.dart';
import 'package:maidc_seller/data/model/response/base/api_response.dart';
import 'package:maidc_seller/data/model/response/response_model.dart';
import 'package:maidc_seller/data/model/response/seller_info.dart';
import 'package:maidc_seller/data/repository/bank_info_repo.dart';
import 'package:maidc_seller/helper/api_checker.dart';
import 'package:http/http.dart' as http;
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/main.dart';
import 'package:maidc_seller/view/base/custom_snackbar.dart';

class BankInfoProvider extends ChangeNotifier {
  final BankInfoRepo? bankInfoRepo;

  BankInfoProvider({required this.bankInfoRepo});

  SellerModel? _bankInfo;
  List<double?>? _userEarnings;
  List<double?>? _userCommissions;
  SellerModel? get bankInfo => _bankInfo;
  List<double?>? get userEarnings => _userEarnings;
  List<double?>? get userCommissions => _userCommissions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _revenueFilterTypeIndex = 0;
  int get revenueFilterTypeIndex => _revenueFilterTypeIndex;
  String? _revenueFilterType = '';
  String? get revenueFilterType => _revenueFilterType;

  void setRevenueFilterName(
      BuildContext context, String? filterName, bool notify) {
    _revenueFilterType = filterName;
    String? callingString;
    if (_revenueFilterType == 'this_year') {
      callingString = 'yearEarn';
    } else if (_revenueFilterType == 'this_month') {
      callingString = 'MonthEarn';
    } else if (_revenueFilterType == 'this_week') {
      callingString = 'WeekEarn';
    }
    getDashboardRevenueData(context, callingString);
    if (notify) {
      notifyListeners();
    }
  }

  void setRevenueFilterType(int index, bool notify) {
    _revenueFilterTypeIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  List<dynamic> _earnings = [];
  List<dynamic> get earnings => _earnings;

  List<dynamic> _commission = [];
  List<dynamic> get commission => _commission;
  double _lim = 0.0;
  double get lim => _lim;

  Future<void> getDashboardRevenueData(
      BuildContext context, String? filterType) async {
    ApiResponse apiResponse = await bankInfoRepo!.chartFilterData(filterType);
    if (apiResponse.response != null &&
        apiResponse.response!.data != null &&
        apiResponse.response!.statusCode == 200) {
      _userEarnings = [];
      _userCommissions = [];
      _earnings = [];
      _commission = [];

      _earnings.addAll(apiResponse.response!.data['seller_earn']);
      _commission.addAll(apiResponse.response!.data['commission_earn']);

      for (dynamic data in _earnings) {
        try {
          _userEarnings!.add(data.toDouble());
        } catch (e) {
          _userEarnings!.add(double.parse(data.toString()));
        }
      }
      for (dynamic data in _commission) {
        try {
          _userCommissions!.add(data.toDouble());
        } catch (e) {
          _userCommissions!.add(double.parse(data.toString()));
        }
      }
      _userEarnings!.insert(0, 0);
      _userCommissions!.insert(0, 0);
      List<double?> counts = [];
      List<double?> comCounts = [];
      counts.addAll(_userEarnings!);
      comCounts.addAll(_userCommissions!);
      counts.sort();
      comCounts.sort();
      double max = 0;
      max = counts.isNotEmpty ? counts[counts.length - 1] ?? 0 : 0;
      double maxx = 0;
      maxx = counts.isNotEmpty ? comCounts[comCounts.length - 1] ?? 0 : 0;
      if (max > maxx) {
        _lim = max;
      } else {
        _lim = maxx;
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getBankInfo(BuildContext context) async {
    ApiResponse apiResponse = await bankInfoRepo!.getBankList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _bankInfo = SellerModel.fromJson(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<ResponseModel?> updateUserInfo(BuildContext context,
      SellerModel updateUserModel, SellerBody seller, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel? responseModel;
    http.StreamedResponse response =
        await bankInfoRepo!.updateBank(updateUserModel, seller, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Navigator.pop(Get.context!);
      showCustomSnackBar(
          getTranslated('bank_info_updated_successfully', Get.context!),
          Get.context!,
          isToaster: true,
          isError: false);
    } else {
      if (kDebugMode) {
        print('${response.statusCode} ${response.reasonPhrase}');
      }
      responseModel = ResponseModel(
          false, '${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return responseModel;
  }

  String getBankToken() {
    return bankInfoRepo!.getBankToken();
  }
}
