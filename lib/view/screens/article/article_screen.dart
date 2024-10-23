import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../../../provider/article_provider.dart';
import 'add_article.dart';
import 'article_card.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ArticleProvider>(context, listen: false).getArticleList();

    return Scaffold(
        appBar: CustomAppBar(title: 'Article'),
        body: SingleChildScrollView(
          child: Consumer<ArticleProvider>(builder: (context, article, child) {
            return article.firstLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: article.articleList.length,
                            itemBuilder: (context, index) {
                              return ArticleCard(
                                  article: article.articleList[index]);
                            }),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddArticleScreen()));
          },
          child: Icon(Icons.add, color: Colors.white),
        ));
  }
}
