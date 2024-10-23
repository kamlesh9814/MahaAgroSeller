import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maidc_seller/data/model/response/article_model.dart';
import 'package:maidc_seller/data/model/response/base/api_response.dart';

import '../data/repository/article_repo.dart';

class ArticleProvider extends ChangeNotifier {
  final ArticleRepo? articleRepo;

  ArticleProvider({@required this.articleRepo});
  bool _isLoading = false;
  bool _firstLoading = true;

  bool _updateLoading = false;
  bool get updateLoading => _updateLoading;

  bool get isLoading => _isLoading;
  bool get firstLoading => _firstLoading;

  List<Article> _articleList = [];

  List<Article> get articleList => _articleList;

  Future<void> getArticleList() async {
    _isLoading = true;

    ApiResponse apiResponse = await articleRepo!.getArticleList();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _articleList.clear();
      apiResponse.response!.data.forEach((article) {
        _articleList.add(Article.fromJson(article));
      });
    } else {
      print(apiResponse.error.toString());
    }
    _isLoading = false;
    _firstLoading = false;
    notifyListeners();
  }

  Future<ApiResponse> addArticle(String title, String desc, File file) async {
    _updateLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await articleRepo!.addArticle(title, desc, file);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      getArticleList();
      notifyListeners();

      return apiResponse;
    } else {
      notifyListeners();
      print(apiResponse.error.toString());
      return apiResponse;
    }
  }
}
