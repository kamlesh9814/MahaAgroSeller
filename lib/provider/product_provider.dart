import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maidc_seller/data/model/response/base/api_response.dart';
import 'package:maidc_seller/data/model/response/product_model.dart';
import 'package:maidc_seller/data/model/response/product_review_model.dart';
import 'package:maidc_seller/data/model/response/review_model.dart' as rm;
import 'package:maidc_seller/data/model/response/top_selling_product_model.dart';
import 'package:maidc_seller/data/repository/product_repo.dart';
import 'package:maidc_seller/helper/api_checker.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/main.dart';
import 'package:maidc_seller/view/base/custom_snackbar.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo? productRepo;
  ProductProvider({required this.productRepo});

  bool _isLoading = false;
  bool _firstLoading = true;
  List<int> _offsetList = [];
  int _offset = 1;

  int _barCodeQuantity = 0;
  int get barCodeQuantity => _barCodeQuantity;

  bool get isLoading => _isLoading;
  bool get firstLoading => _firstLoading;
  int get offset => _offset;

  String? _printBarCode = '';
  String? get printBarCode => _printBarCode;

  bool _isGetting = false;
  bool get isGetting => _isGetting;

  final List<bool> _isOn = [];
  List<bool> get isOn => _isOn;

  List<rm.ReviewModel> _productReviewList = [];
  List<rm.ReviewModel> get productReviewList => _productReviewList;

  ProductReviewModel? _productReviewModel;
  ProductReviewModel? get productReviewModel => _productReviewModel;

  List<Product> _sellerProductList = [];
  List<Product> _stockOutProductList = [];
  List<Product> _mostPopularProductList = [];
  final List<Products> _topSellingProductList = [];
  List<Product> _posProductList = [];

  TopSellingProductModel? _topSellingProductModel;
  TopSellingProductModel? get topSellingProductModel => _topSellingProductModel;

  List<Product> get mostPopularProductList => _mostPopularProductList;
  List<Products> get topSellingProductList => _topSellingProductList;
  List<Product> get sellerProductList => _sellerProductList;
  List<Product> get stockOutProductList => _stockOutProductList;
  List<Product> get posProductList => _posProductList;

  ProductModel? _posProductModel;
  ProductModel? get posProductModel => _posProductModel;

  Product? _productDetails;
  Product? get productDetails => _productDetails;

  int? _sellerPageSize;
  int? _stockOutProductPageSize;

  int? get sellerPageSize => _sellerPageSize;
  int? get stockOutProductPageSize => _stockOutProductPageSize;

  int? _variantIndex;
  List<int>? _variationIndex;
  int? get variantIndex => _variantIndex;
  List<int>? get variationIndex => _variationIndex;
  int? _quantity = 0;
  int? get quantity => _quantity;

  ProductModel? _sellerProductModel;
  ProductModel? get sellerProductModel => _sellerProductModel;

  void initData(
      Product product, int? minimumOrderQuantity, BuildContext context) {
    _variantIndex = 0;
    _quantity = minimumOrderQuantity;
    _variationIndex = [];
    for (int i = 0; i <= product.choiceOptions!.length; i++) {
      _variationIndex!.add(0);
    }
  }

  void setQuantity(int value) {
    _quantity = value;
    notifyListeners();
  }

  void setCartVariantIndex(
      int? minimumOrderQuantity, int index, BuildContext context) {
    _variantIndex = index;
    _quantity = minimumOrderQuantity;
    notifyListeners();
  }

  void setCartVariationIndex(
      int? minimumOrderQuantity, int index, int i, BuildContext context) {
    _variationIndex![index] = i;
    _quantity = minimumOrderQuantity;
    notifyListeners();
  }

  int? _reviewProductIndex = 0;
  int? get reviewProductIndex => _reviewProductIndex;

  List<int?> _reviewProductIds = [];
  List<int?> get reviewProductIds => _reviewProductIds;

  int? _selectedProductId = 0;
  int? get selectedProductId => _selectedProductId;

  String selectedProductName = 'Select';
  void setReviewProductIndex(
      int? index, int? productId, String? productName, bool notify) {
    _reviewProductIndex = index;
    _selectedProductId = productId;
    selectedProductName = productName!;
    if (notify) {
      Navigator.of(Get.context!).pop();
      notifyListeners();
    }
  }

  Future<void> initSellerProductList(String sellerId, int offset,
      BuildContext context, String languageCode, String search,
      {bool reload = true}) async {
    _reviewProductIds = [];
    _reviewProductIds.add(0);
    if (reload) {
      _isLoading = true;
    }
    ApiResponse apiResponse = await productRepo!
        .getSellerProductList(sellerId, offset, languageCode, search);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (offset == 1) {
        _sellerProductModel = null;
        _sellerProductModel = ProductModel.fromJson(apiResponse.response!.data);
      } else {
        _sellerProductModel!.products!.addAll(
            ProductModel.fromJson(apiResponse.response!.data).products ?? []);
        _sellerPageSize =
            ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _sellerProductModel!.offset =
            ProductModel.fromJson(apiResponse.response!.data).offset;
        _sellerProductModel!.totalSize =
            ProductModel.fromJson(apiResponse.response!.data).totalSize;
      }
      _reviewProductIndex = 0;
      for (int i = 0; i < _sellerProductModel!.products!.length; i++) {
        _reviewProductIds.add(_sellerProductModel!.products![i].id);
      }
      _firstLoading = false;
      _isLoading = false;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  List<int?> _cartQuantity = [];
  List<int?> get cartQuantity => _cartQuantity;

  Future<void> getPosProductList(
      int offset, BuildContext context, List<String> id,
      {bool reload = true}) async {
    _isLoading = true;
    ApiResponse apiResponse = await productRepo!.getPosProductList(offset, id);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (offset == 1) {
        _cartQuantity = [];
        _posProductModel = ProductModel.fromJson(apiResponse.response!.data);
      } else {
        _posProductModel!.totalSize =
            ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _posProductModel!.offset =
            ProductModel.fromJson(apiResponse.response!.data).offset;
        _posProductModel!.products!.addAll(
            ProductModel.fromJson(apiResponse.response!.data).products!);
      }
      for (int i = 0; i < _posProductModel!.products!.length; i++) {
        _cartQuantity.add(0);
      }
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void setCartQuantity(int? quantity, int index) {
    _cartQuantity[index] = quantity;
  }

  bool _showDialog = false;
  bool get showDialog => _showDialog;
  void shoHideDialog(bool showDialog) {
    _showDialog = showDialog;
    notifyListeners();
  }

  Future<void> getSearchedPosProductList(
      BuildContext context, String search, List<String> ids,
      {bool filter = false}) async {
    if (!filter) {
      shoHideDialog(true);
    }

    ApiResponse apiResponse =
        await productRepo!.getSearchedPosProductList(search, ids);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _posProductList = [];
      _posProductList
          .addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
      _sellerPageSize =
          ProductModel.fromJson(apiResponse.response!.data).totalSize;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getStockOutProductList(int offset, String languageCode,
      {bool reload = false}) async {
    if (reload || offset == 1) {
      _offset = 1;
      _offsetList = [];
      _stockOutProductList = [];
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse =
          await productRepo!.getStockLimitedProductList(offset, languageCode);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _stockOutProductList = [];
        _stockOutProductList.addAll(
            ProductModel.fromJson(apiResponse.response!.data).products!);
        _stockOutProductPageSize =
            ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
    } else {
      if (_isLoading) {
        _isLoading = false;
      }
    }
  }

  Future<void> getMostPopularProductList(
      int offset, BuildContext context, String languageCode,
      {bool reload = false}) async {
    if (reload || offset == 1) {
      _offset = 1;
      _offsetList = [];
      _mostPopularProductList = [];
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse =
          await productRepo!.getMostPopularProductList(offset, languageCode);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _mostPopularProductList.addAll(
            ProductModel.fromJson(apiResponse.response!.data).products!);
        _stockOutProductPageSize =
            ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
    } else {
      if (_isLoading) {
        _isLoading = false;
      }
    }
  }

  Future<void> getTopSellingProductList(
      int offset, BuildContext context, String languageCode,
      {bool reload = true}) async {
    ApiResponse apiResponse =
        await productRepo!.getTopSellingProductList(offset, languageCode);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (offset == 1) {
        _topSellingProductModel =
            TopSellingProductModel.fromJson(apiResponse.response!.data);
      } else {
        _topSellingProductModel!.totalSize =
            TopSellingProductModel.fromJson(apiResponse.response!.data)
                .totalSize;
        _topSellingProductModel!.offset =
            TopSellingProductModel.fromJson(apiResponse.response!.data).offset;
        _topSellingProductModel!.products!.addAll(
            TopSellingProductModel.fromJson(apiResponse.response!.data)
                .products!);
      }
      _isLoading = false;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getProductWiseReviewList(
      BuildContext context, int offset, int? productId,
      {bool reload = false}) async {
    if (reload || offset == 1) {
      _offset = 1;
      _offsetList = [];
      _productReviewList = [];
      _firstLoading = true;
    }
    _isLoading = true;
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse =
          await productRepo!.getProductWiseReviewList(productId, offset);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _productReviewModel =
            ProductReviewModel.fromJson(apiResponse.response!.data);
        _productReviewList.addAll(_productReviewModel!.reviews!);
        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
    } else {
      if (_isLoading) {
        _isLoading = false;
      }
    }
  }

  Future<void> getProductDetails(int? productId) async {
    _isLoading = true;
    ApiResponse apiResponse = await productRepo!.getProductDetails(productId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _productDetails = Product.fromJson(apiResponse.response!.data);
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> productStatusOnOff(
      BuildContext context, int? productId, int status) async {
    ApiResponse apiResponse =
        await productRepo!.productStatusOnOff(productId, status);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _productDetails!.status = status;
      showCustomSnackBar(
          getTranslated('status_updated_successfully', Get.context!),
          Get.context!,
          isError: false);
      getProductDetails(productId);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void removeFirstLoading() {
    _firstLoading = true;
    notifyListeners();
  }

  Future<int?> getLatestOffset(String sellerId, String languageCode) async {
    ApiResponse apiResponse =
        await productRepo!.getSellerProductList(sellerId, 1, languageCode, '');
    return ProductModel.fromJson(apiResponse.response!.data).totalSize;
  }

  void clearSellerData() {
    _sellerProductList = [];
    notifyListeners();
  }

  void setBarCodeQuantity(int quantity) {
    _barCodeQuantity = quantity;
    if (kDebugMode) {
      print('Quantity is ==>$_barCodeQuantity');
    }
    notifyListeners();
  }

  Future<void> barCodeDownload(
      BuildContext context, int? id, int quantity) async {
    _isGetting = true;
    ApiResponse apiResponse = await productRepo!.barCodeDownLoad(id, quantity);
    if (apiResponse.response!.statusCode == 200) {
      _printBarCode = apiResponse.response!.data;
      showCustomSnackBar(
          getTranslated('barcode_downloaded_successfully', Get.context!),
          Get.context!,
          isError: false);

      _isGetting = false;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isGetting = false;
    notifyListeners();
  }
}
