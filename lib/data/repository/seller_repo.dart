import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/data/datasource/remote/dio/dio_client.dart';
import 'package:maidc_seller/data/datasource/remote/exception/api_error_handler.dart';
import 'package:maidc_seller/data/model/response/add_product_model.dart';
import 'package:maidc_seller/data/model/response/base/api_response.dart';
import 'package:maidc_seller/data/model/response/image_model.dart';
import 'package:maidc_seller/data/model/response/product_model.dart';
import 'package:maidc_seller/main.dart';
import 'package:maidc_seller/provider/auth_provider.dart';
import 'package:maidc_seller/provider/splash_provider.dart';
import 'package:maidc_seller/utill/app_constants.dart';

class SellerRepo {
  final DioClient? dioClient;
  SellerRepo({required this.dioClient});

  Future<ApiResponse> getAttributeList(String languageCode) async {
    try {
      final response = await dioClient!.get(
        AppConstants.attributeUri,
        options: Options(headers: {AppConstants.langKey: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBrandList(String languageCode) async {
    try {
      final response = await dioClient!.get(
        AppConstants.brandUri,
        options: Options(headers: {AppConstants.langKey: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getEditProduct(int? id) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.editProductUri}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryList(String languageCode) async {
    try {
      final response = await dioClient!.get(
        AppConstants.categoryUri,
        options: Options(headers: {AppConstants.langKey: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubCategoryList() async {
    try {
      final response = await dioClient!.get(AppConstants.categoryUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubSubCategoryList() async {
    try {
      final response = await dioClient!.get(AppConstants.categoryUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addImage(BuildContext context, ImageModel imageForUpload,
      bool colorActivate) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.uploadProductImageUri}',
        ));
    if (kDebugMode) {
      print('==image is exist or not=${imageForUpload.image!.path}');
    }
    request.headers.addAll(<String, String>{
      'Authorization':
          'Bearer ${Provider.of<AuthProvider>(context, listen: false).getUserToken()}'
    });
    if (Platform.isAndroid || Platform.isIOS && imageForUpload.image != null) {
      File file = File(imageForUpload.image!.path);
      request.files.add(http.MultipartFile(
          'image', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'type': imageForUpload.type!,
      'color': imageForUpload.color!,
      'colors_active': colorActivate.toString()
    });
    request.fields.addAll(fields);
    if (kDebugMode) {
      print('=====> ${request.url.path}\n${request.fields}');
    }

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    if (kDebugMode) {
      print('=====Response body is here==>${res.body}');
    }

    try {
      return ApiResponse.withSuccess(Response(
          statusCode: response.statusCode,
          requestOptions: RequestOptions(path: ''),
          statusMessage: response.reasonPhrase,
          data: res.body));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addProduct(
      Product product,
      AddProductModel addProduct,
      Map<String, dynamic> attributes,
      List<String?>? productImages,
      String? thumbnail,
      String? metaImage,
      String token,
      bool isAdd,
      bool isActiveColor,
      List<ColorImage> colorImageObject,
      List<String?> tags) async {
    dioClient!.dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    Map<String, dynamic> fields = {};
    fields.addAll(<String, dynamic>{
      'name': addProduct.titleList,
      'description': addProduct.descriptionList,
      'unit_price': product.unitPrice,
      'purchase_price': product.purchasePrice,
      'discount': product.discount,
      'discount_type': product.discountType,
      'tax': product.tax,
      'tax_model': product.taxModel,
      'category_id': product.categoryIds![0].id,
      'unit': product.unit,
      'brand_id': Provider.of<SplashProvider>(Get.context!, listen: false)
                  .configModel!
                  .brandSetting ==
              "1"
          ? product.brandId
          : null,
      'meta_title': product.metaTitle,
      'meta_description': product.metaDescription,
      'lang': addProduct.languageList,
      'colors': addProduct.colorCodeList,
      'images': productImages,
      'color_image': colorImageObject,
      'thumbnail': thumbnail,
      'colors_active': isActiveColor,
      'video_url': addProduct.videoUrl,
      'meta_image': metaImage,
      'current_stock': product.currentStock,
      'shipping_cost': product.shippingCost,
      'multiply_qty': product.multiplyWithQuantity,
      'code': product.code,
      'minimum_order_qty': product.minimumOrderQty,
      'product_type': product.productType,
      "digital_product_type": product.digitalProductType,
      "digital_file_ready": product.digitalFileReady,
      "tags": tags
    });
    if (product.categoryIds!.length > 1) {
      fields.addAll(
          <String, dynamic>{'sub_category_id': product.categoryIds![1].id});
    }
    if (product.categoryIds!.length > 2) {
      fields.addAll(
          <String, dynamic>{'sub_sub_category_id': product.categoryIds![2].id});
    }
    if (!isAdd) {
      fields.addAll(<String, dynamic>{'_method': 'put', 'id': product.id});
    }
    if (attributes.isNotEmpty) {
      fields.addAll(attributes);
    }

    if (kDebugMode) {
      print('==========Response Body======>$fields');
    }

    try {
      Response response = await dioClient!.post(
        '${AppConstants.baseUrl}${isAdd ? AppConstants.addProductUri : '${AppConstants.updateProductUri}/${product.id}'}',
        data: fields,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteProduct(int? productID) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.deleteProductUri}/$productID',
          data: {'_method': 'delete'});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> uploadDigitalProduct(File? filePath, String token) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.digitalProductUpload}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    if (filePath != null) {
      Uint8List list = await filePath.readAsBytes();
      var part = http.MultipartFile(
          'digital_file_ready', filePath.readAsBytes().asStream(), list.length,
          filename: basename(filePath.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{});

    request.fields.addAll(fields);
    if (kDebugMode) {
      print('=====> ${request.url.path}\n${request.fields}');
    }

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    if (kDebugMode) {
      print('=====Response body is here==>${res.body}');
    }

    try {
      return ApiResponse.withSuccess(Response(
          statusCode: response.statusCode,
          requestOptions: RequestOptions(path: ''),
          statusMessage: response.reasonPhrase,
          data: res.body));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> uploadAfterSellDigitalProduct(
      File? filePath, String token, String orderId) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.digitalProductUploadAfterSell}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    if (kDebugMode) {
      print('Here is ===>$filePath');
    }
    if (filePath != null) {
      Uint8List list = await filePath.readAsBytes();
      var part = http.MultipartFile('digital_file_after_sell',
          filePath.readAsBytes().asStream(), list.length,
          filename: basename(filePath.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{'order_id': orderId, '_method': 'put'});

    request.fields.addAll(fields);
    if (kDebugMode) {
      print('=====> ${request.url.path}\n${request.fields}');
    }

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    if (kDebugMode) {
      print('=====Response body is here==>${res.body}');
    }

    try {
      return ApiResponse.withSuccess(Response(
          statusCode: response.statusCode,
          requestOptions: RequestOptions(path: ''),
          statusMessage: response.reasonPhrase,
          data: res.body));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateProductQuantity(
      int? productId, int currentStock, List<Variation> variation) async {
    try {
      final response =
          await dioClient!.post(AppConstants.updateProductQuantity, data: {
        "product_id": productId,
        "current_stock": currentStock,
        "variation": variation,
        "_method": "put"
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
