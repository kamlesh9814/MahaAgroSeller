import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maidc_seller/data/model/response/base/api_response.dart';
import 'package:maidc_seller/data/model/response/coupon_model.dart';
import 'package:maidc_seller/data/model/response/customer_model.dart';
import 'package:maidc_seller/data/repository/coupon_repo.dart';
import 'package:maidc_seller/helper/api_checker.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/main.dart';
import 'package:maidc_seller/view/base/custom_snackbar.dart';

class CouponProvider with ChangeNotifier {
  final CouponRepo? couponRepo;

  CouponProvider({required this.couponRepo});

  CouponModel? _couponModel;
  CouponModel? get couponModel => _couponModel;

  List<Coupons> _couponList = [];
  List<Coupons> get couponList => _couponList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAdd = false;
  bool get isAdd => _isAdd;

  String? _selectedCouponType = 'discount_on_purchase';
  String? get selectedCouponType => _selectedCouponType;
  final List<String> _couponTypeList = [
    'discount_on_purchase',
    'free_delivery'
  ];
  List<String> get couponTypeList => _couponTypeList;

  void setSelectedCouponType(String? type) {
    _selectedCouponType = type;
    notifyListeners();
  }

  String? _discountTypeName = 'amount';
  String? get discountTypeName => _discountTypeName;
  List<String> discountTypeList = ['amount', 'percentage'];

  void setSelectedDiscountNameType(String? type) {
    _discountTypeName = type;
    notifyListeners();
  }

  Future<void> getCouponList(BuildContext context, int offset,
      {bool reload = true}) async {
    if (reload) {
      _couponList = [];
    }
    _isLoading = true;
    ApiResponse apiResponse = await couponRepo!.getCouponList(offset);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      _couponModel = CouponModel.fromJson(apiResponse.response!.data);
      _couponList.addAll(_couponModel!.coupons!);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> addNewCoupon(
      BuildContext context, Coupons coupons, bool update) async {
    _isAdd = true;
    ApiResponse apiResponse =
        await couponRepo!.addNewCoupon(coupons, update: update);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      getCouponList(Get.context!, 1);
      _isAdd = false;
      startDate = null;
      endDate = null;
      Navigator.pop(Get.context!);
      update
          ? showCustomSnackBar(
              getTranslated('coupon_updated_successfully', Get.context!),
              Get.context!,
              isError: false)
          : showCustomSnackBar(
              getTranslated('coupon_added_successfully', Get.context!),
              Get.context!,
              isError: false);
    } else {
      _isAdd = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> updateCouponStatus(
      BuildContext context, int? id, int status, index) async {
    ApiResponse response = await couponRepo!.updateCouponStatus(id, status);
    if (response.response!.statusCode == 200) {
      _couponList[index].status = status;
      showCustomSnackBar(
          getTranslated('coupon_status_update_successfully', Get.context!),
          Get.context!,
          isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }

  Future<void> deleteCoupon(BuildContext context, int? id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await couponRepo!.deleteCoupon(id);
    if (apiResponse.response!.statusCode == 200) {
      getCouponList(Get.context!, 1);
      _isLoading = false;
      showCustomSnackBar(
          getTranslated('coupon_deleted_successfully', Get.context!),
          Get.context!,
          isError: false);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  DateTime? startDate;
  DateTime? endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateFormat get dateFormat => _dateFormat;

  void selectDate(String type, BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((date) {
      if (type == 'start') {
        startDate = date;
      } else {
        endDate = date;
      }
      if (date == null) {}
      notifyListeners();
    });
  }

  List<Customers>? _couponCustomerList;
  List<Customers>? get couponCustomerList => _couponCustomerList;
  final List<int?> _couponCustomerIds = [];
  List<int?> get couponCustomerIds => _couponCustomerIds;
  int? _couponCustomerIndex = 0;
  int? get couponCustomerIndex => _couponCustomerIndex;
  int? _selectedCustomerIdForCoupon = 0;
  int? get selectedCustomerIdForCoupon => _selectedCustomerIdForCoupon;
  final TextEditingController _searchCustomerController =
      TextEditingController();
  TextEditingController get searchCustomerController =>
      _searchCustomerController;

  String _customerSelectedName = '';
  String get customerSelectedName => _customerSelectedName;

  final String _customerSelectedMobile = '';
  String get customerSelectedMobile => _customerSelectedMobile;

  int? _customerId = 0;
  int? get customerId => _customerId;

  void setCouponCustomerIndex(int index, int customerId, bool notify) {
    _couponCustomerIndex = index;
    _selectedCustomerIdForCoupon = customerId;
    if (notify) {
      notifyListeners();
    }
  }

  void setCustomerInfo(int? id, String name, bool notify) {
    _customerId = id;
    _customerSelectedName = name;

    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getCouponCustomerList(
      BuildContext context, String search) async {
    _isLoading = true;
    ApiResponse response = await couponRepo!.getCouponCustomerList(search);
    if (response.response!.statusCode == 200) {
      _isLoading = false;
      _couponCustomerList = [];
      _couponCustomerList!
          .addAll(CustomerModel.fromJson(response.response!.data).customers!);
      if (_couponCustomerList!.isNotEmpty) {
        for (int index = 0; index < _couponCustomerList!.length; index++) {
          _couponCustomerIds.add(_couponCustomerList![index].id);
        }
        _couponCustomerIndex = _couponCustomerIds[0];
        _selectedCustomerIdForCoupon = _couponCustomerIds[0];
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    notifyListeners();
  }
}
