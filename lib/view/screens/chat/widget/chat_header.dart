import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/localization/language_constrants.dart';
import 'package:maidc_seller/provider/chat_provider.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/utill/images.dart';
import 'package:maidc_seller/view/base/custom_search_field.dart';
import 'package:maidc_seller/view/screens/chat/widget/chat_type_button.dart';

class ChatHeader extends StatefulWidget {
  const ChatHeader({Key? key}) : super(key: key);

  @override
  State<ChatHeader> createState() => _ChatHeaderState();
}

class _ChatHeaderState extends State<ChatHeader> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chat, _) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            Dimensions.paddingSizeDefault,
            Dimensions.paddingSizeDefault,
            Dimensions.paddingSizeDefault,
            Dimensions.paddingSizeSmall),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: CustomSearchField(
                  controller: _textEditingController,
                  hint: getTranslated('search', context),
                  prefix: Images.iconsSearch,
                  iconPressed: () => () {},
                  onSubmit: (text) => () {},
                  onChanged: (value) {
                    if (value.toString().isNotEmpty) {
                      chat.searchedChatList(context, value);
                    }
                  },
                ),
              ),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    ChatTypeButton(
                        text: getTranslated('customer', context), index: 0),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    ChatTypeButton(
                        text: getTranslated('delivery-man', context), index: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
