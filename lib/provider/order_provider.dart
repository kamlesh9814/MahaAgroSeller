import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maidc_seller/data/model/response/base/api_response.dart';
import 'package:maidc_seller/data/model/response/business_analytics_filter_data.dart';
import 'package:maidc_seller/data/model/response/invoice_model.dart';
import 'package:maidc_seller/data/model/response/order_details_model.dart';
import 'package:maidc_seller/data/model/response/order_model.dart';
import 'package:maidc_seller/data/repository/order_repo.dart';
import 'package:maidc_seller/helper/api_checker.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/main.dart';
import 'package:maidc_seller/view/base/custom_snackbar.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;
  OrderProvider({required this.orderRepo});

  String? _paymentStatus;
  String? get paymentStatus => _paymentStatus;
  String? _orderStatus;
  String? get orderStatus => _orderStatus;
  OrderModel? _orderModel;
  OrderModel? get orderModel => _orderModel;

  double _discountOnProduct = 0;
  double get discountOnProduct => _discountOnProduct;

  double _totalTaxAmount = 0;
  double get totalTaxAmount => _totalTaxAmount;
  final int _offset = 1;
  int get offset => _offset;

  List<OrderDetailsModel>? _orderDetails;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _orderTypeIndex = 0;
  int get orderTypeIndex => _orderTypeIndex;

  List<String> _orderStatusList = [];
  String? _orderStatusType = '';
  List<String> get orderStatusList => _orderStatusList;
  String? get orderStatusType => _orderStatusType;

  String? _addOrderStatusErrorText;
  String? get addOrderStatusErrorText => _addOrderStatusErrorText;

  List<String>? _paymentImageList;
  List<String>? get paymentImageList => _paymentImageList;

  int _paymentMethodIndex = 0;
  int get paymentMethodIndex => _paymentMethodIndex;
  File? _selectedFileForImport;
  File? get selectedFileForImport => _selectedFileForImport;

  void setOrderStatusErrorText(String errorText) {
    _addOrderStatusErrorText = errorText;
    notifyListeners();
  }

  Future<ApiResponse> updateOrderStatus(
      int? id, String? status, BuildContext context) async {
    ApiResponse apiResponse = await orderRepo!.orderStatus(id, status);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? message = map['message'];

      showCustomSnackBar(message, Get.context!,
          isToaster: true, isError: false);
      getOrderList(Get.context!, 1, 'all');
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<void> getOrderList(BuildContext? context, int offset, String status,
      {bool reload = true}) async {
    if (reload) {
      _orderModel = null;
    }
    _isLoading = true;
    ApiResponse apiResponse = await orderRepo!.getOrderList(offset, status);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (offset == 1) {
        _orderModel = OrderModel.fromJson(apiResponse.response!.data);
      } else {
        _orderModel!.totalSize =
            OrderModel.fromJson(apiResponse.response!.data).totalSize;
        _orderModel!.offset =
            OrderModel.fromJson(apiResponse.response!.data).offset;
        _orderModel!.orders!
            .addAll(OrderModel.fromJson(apiResponse.response!.data).orders!);
      }

      for (Order order in _orderModel!.orders!) {
        _paymentStatus = order.paymentStatus;
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void setPaymentStatus(String? status) {
    _paymentStatus = status;
  }

  String _orderType = 'all';
  String get orderType => _orderType;

  void setIndex(BuildContext context, int index, {bool notify = true}) {
    _orderTypeIndex = index;
    if (_orderTypeIndex == 0) {
      _orderType = 'all';
      getOrderList(context, 1, 'all');
    } else if (_orderTypeIndex == 1) {
      _orderType = 'pending';
      getOrderList(context, 1, 'pending');
    } else if (_orderTypeIndex == 2) {
      _orderType = 'processing';
      getOrderList(context, 1, 'processing');
    } else if (_orderTypeIndex == 3) {
      _orderType = 'delivered';
      getOrderList(context, 1, 'delivered');
    } else if (_orderTypeIndex == 4) {
      _orderType = 'return';
      getOrderList(context, 1, 'returned');
    } else if (_orderTypeIndex == 5) {
      _orderType = 'failed';
      getOrderList(context, 1, 'failed');
    } else if (_orderTypeIndex == 6) {
      _orderType = 'cancelled';
      getOrderList(context, 1, 'canceled');
    } else if (_orderTypeIndex == 7) {
      _orderType = 'confirmed';
      getOrderList(context, 1, 'confirmed');
    } else if (_orderTypeIndex == 8) {
      _orderType = 'out_for_delivery';
      getOrderList(context, 1, 'out_for_delivery');
    }
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getOrderDetails(String orderID) async {
    _orderDetails = null;
    ApiResponse apiResponse = await orderRepo!.getOrderDetails(orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response!.data.forEach(
          (order) => _orderDetails!.add(OrderDetailsModel.fromJson(order)));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void initOrderStatusList(String type) async {
    ApiResponse apiResponse = await orderRepo!.getOrderStatusList(type);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _orderStatusList = [];
      _orderStatusList.addAll(apiResponse.response!.data);
      _orderStatusType = apiResponse.response!.data[0];
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void updateStatus(String? value, {bool notify = true}) {
    _orderStatusType = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setPaymentMethodIndex(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }

  final bool _selfDelivery = false;
  final bool _thirdPartyDelivery = false;
  bool get selfDelivery => _selfDelivery;
  bool get thirdPartyDelivery => _thirdPartyDelivery;

  FilePickerResult? _otherFile;
  FilePickerResult? get otherFile => _otherFile;

  PlatformFile? fileNamed;
  File? file;
  int? fileSize;

  void pickOtherFile(bool isRemove) async {
    if (isRemove) {
      _otherFile = null;
    } else {
      _otherFile = (await FilePicker.platform.pickFiles(withReadStream: true))!;
      if (_otherFile != null) {
        file = File(_otherFile!.files.single.path!);
        fileSize = await file!.length();
        fileNamed = _otherFile!.files.first;
        setSelectedFileName(file);
      }
    }
    notifyListeners();
  }

  Future updatePaymentStatus(
      {int? orderId, String? status, BuildContext? context}) async {
    ApiResponse apiResponse =
        await orderRepo!.updatePaymentStatus(orderId: orderId, status: status);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      getOrderList(Get.context!, 1, 'all');
      String? message =
          getTranslated('payment_status_updated_successfully', Get.context!);
      showCustomSnackBar(message, Get.context!,
          isToaster: true, isError: false);
    } else if (apiResponse.response!.statusCode == 202) {
      Map map = apiResponse.response!.data;
      String? message = map['message'];
      showCustomSnackBar(message, Get.context!, isError: true);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void setSelectedFileName(File? fileName) {
    _selectedFileForImport = fileName;
    notifyListeners();
  }

  Future setDeliveryCharge(
      {int? orderId,
      String? deliveryCharge,
      String? deliveryDate,
      BuildContext? context}) async {
    ApiResponse apiResponse = await orderRepo!
        .setDeliveryCharge(orderId, deliveryCharge, deliveryDate);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? message = map['message'];
      showCustomSnackBar(message, Get.context!, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  DateTime? _startDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime? get startDate => _startDate;
  DateFormat get dateFormat => _dateFormat;

  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((date) {
      _startDate = date;

      notifyListeners();
    });
  }

  InvoiceModel? _invoice;
  InvoiceModel? get invoice => _invoice;
  Future<void> getInvoiceData(int? orderId) async {
    _isLoading = true;
    ApiResponse response = await orderRepo!.getInvoiceData(orderId);
    if (response.response != null && response.response!.statusCode == 200) {
      _discountOnProduct = 0;
      _totalTaxAmount = 0;
      _invoice = InvoiceModel.fromJson(response.response!.data);
      for (int i = 0; i < _invoice!.details!.length; i++) {
        _discountOnProduct += invoice!.details![i].discount!;
        if (invoice!.details![i].productDetails!.taxModel == "exclude") {
          _totalTaxAmount += invoice!.details![i].tax!;
        }
      }
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }

  String? _analyticsName = '';
  String? get analyticsName => _analyticsName;
  int _analyticsIndex = 0;
  int get analyticsIndex => _analyticsIndex;

  void setAnalyticsFilterName(
      BuildContext context, String? filterName, bool notify) {
    _analyticsName = filterName;
    getAnalyticsFilterData(context, _analyticsName);
    if (notify) {
      notifyListeners();
    }
  }

  void setAnalyticsFilterType(int index, bool notify) {
    _analyticsIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  BusinessAnalyticsFilterData? _businessAnalyticsFilterData;
  BusinessAnalyticsFilterData? get businessAnalyticsFilterData =>
      _businessAnalyticsFilterData;

  Future<void> getAnalyticsFilterData(
      BuildContext context, String? type) async {
    _isLoading = true;
    ApiResponse response = await orderRepo!.getOrderFilterData(type);
    if (response.response != null && response.response!.statusCode == 200) {
      _businessAnalyticsFilterData =
          BusinessAnalyticsFilterData.fromJson(response.response!.data);
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }

  bool assigning = false;
  Future<ApiResponse> assignThirdPartyDeliveryMan(BuildContext context,
      String name, String trackingId, int? orderId) async {
    assigning = true;
    notifyListeners();
    ApiResponse apiResponse =
        await orderRepo!.assignThirdPartyDeliveryMan(name, trackingId, orderId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(
          getTranslated('third_party_delivery_type_successfully', Get.context!),
          Get.context!,
          isToaster: true,
          isError: false);
      assigning = false;
      getOrderList(Get.context!, 1, 'all');
    } else {
      assigning = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> editShippingAndBillingAddress({
    String? orderID,
    String? addressType,
    String? contactPersonName,
    String? phone,
    String? city,
    String? zip,
    String? address,
    String? email,
    String? latitude,
    String? longitude,
  }) async {
    assigning = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo!.orderAddressEdit(
        orderID: orderID,
        addressType: addressType,
        contactPersonName: contactPersonName,
        phone: phone,
        city: city,
        zip: zip,
        address: address,
        email: email,
        latitude: latitude,
        longitude: longitude);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Navigator.of(Get.context!).pop();
      showCustomSnackBar(
          getTranslated('address_updated_successfully', Get.context!),
          Get.context!,
          isToaster: true,
          isError: false);
    } else {
      assigning = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }
}
