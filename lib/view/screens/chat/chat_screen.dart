import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:maidc_seller/provider/chat_provider.dart';
import 'package:maidc_seller/utill/color_resources.dart';
import 'package:maidc_seller/utill/dimensions.dart';
import 'package:maidc_seller/view/base/custom_app_bar.dart';
import 'package:maidc_seller/view/screens/chat/widget/chat_shimmer.dart';
import 'package:maidc_seller/view/screens/chat/widget/message_bubble.dart';
import 'package:maidc_seller/view/screens/chat/widget/send_message_widget.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final int? userId;
  const ChatScreen({Key? key, required this.userId, this.name = ''})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false)
        .getMessageList(widget.userId, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Consumer<ChatProvider>(builder: (context, chat, child) {
        return Column(children: [
          CustomAppBar(title: widget.name),

          // Chats
          Expanded(
              child: chat.messageList != null
                  ? chat.messageList!.isNotEmpty
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          itemCount: chat.messageList!.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return MessageBubble(
                                message: chat.messageList![index]);
                          },
                        )
                      : const SizedBox.shrink()
                  : const ChatShimmer()),

          SendMessageWidget(id: widget.userId)
        ]);
      }),
    );
  }
}
