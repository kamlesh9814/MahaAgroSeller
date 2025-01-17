import 'package:flutter/cupertino.dart';
import 'package:maidc_seller/data/model/response/base/api_response.dart';
import 'package:maidc_seller/data/model/response/emergency_contact_model.dart';
import 'package:maidc_seller/data/repository/emergency_contact_repo.dart';
import 'package:maidc_seller/helper/api_checker.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/main.dart';
import 'package:maidc_seller/view/base/custom_snackbar.dart';

class EmergencyContactProvider extends ChangeNotifier {
  final EmergencyContactRepo? emergencyContactRepo;
  EmergencyContactProvider({required this.emergencyContactRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<ContactList> _contactList = [];
  List<ContactList> get contactList => _contactList;
  late EmergencyContactModel _emergencyContactModel;

  Future<void> getEmergencyContactListList() async {
    _isLoading = true;
    ApiResponse apiResponse =
        await emergencyContactRepo!.getEmergencyContactListList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _contactList = [];
      _isLoading = false;
      _emergencyContactModel =
          EmergencyContactModel.fromJson(apiResponse.response!.data);
      _contactList.addAll(_emergencyContactModel.contactList!);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }

    notifyListeners();
  }

  Future<void> statusOnOffEmergencyContact(
      BuildContext context, int? id, int status, int? index) async {
    ApiResponse apiResponse;
    apiResponse =
        await emergencyContactRepo!.statusOnOffEmergencyContact(id, status);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _contactList[index!].status = status;

      Map map = apiResponse.response!.data;
      showCustomSnackBar(map['message'], Get.context!,
          isToaster: true, isError: false);
    } else {
      Map map = apiResponse.response!.data;
      showCustomSnackBar(map['message'], Get.context!, isToaster: true);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteEmergencyContact(BuildContext context, int? id) async {
    ApiResponse apiResponse;
    apiResponse = await emergencyContactRepo!.deleteEmergencyContact(id);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      getEmergencyContactListList();
      String? message = apiResponse.response!.data['message'];
      showCustomSnackBar(message, Get.context!, isError: false);
    } else {
      String? message = apiResponse.response!.data['message'];
      showCustomSnackBar(message, Get.context!);
    }
    notifyListeners();
  }

  Future<ApiResponse> addNewEmergencyContact(
      BuildContext context, String name, String phone, int? id,
      {bool isUpdate = false}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await emergencyContactRepo!
        .addNewEmergencyContact(name, phone, id, isUpdate: isUpdate);
    if (response.response!.statusCode == 200) {
      getEmergencyContactListList();
      Navigator.pop(Get.context!);
      isUpdate
          ? showCustomSnackBar(
              getTranslated("contact_updated_successfully", Get.context!),
              Get.context!,
              isError: false)
          : showCustomSnackBar(
              getTranslated("contact_added_successfully", Get.context!),
              Get.context!,
              isError: false);
    } else {
      _isLoading = false;
    }
    _isLoading = false;
    notifyListeners();
    return response;
  }
}
