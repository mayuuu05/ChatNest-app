import 'dart:developer';
import 'package:chatting_application/services/local_notification_service.dart';
import 'package:chatting_application/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../model/chat_model.dart';
import '../../services/auth_service.dart';
import '../../services/cloud_firestore_service.dart';
import 'home_screen.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            buildContainer(),
            Expanded(
              child: StreamBuilder(
                stream: CloudFireStoreServices.cloudFireStoreServices
                    .readChatFromFireStore(chatController.receiverEmail.value),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error.toString()}"),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("");
                  }

                  List data = snapshot.data!.docs;
                  List<ChatModel> chatList = [];
                  List<String> docIdList = [];

                  for (QueryDocumentSnapshot snap in data) {
                    try {
                      docIdList.add(snap.id);
                      chatList.add(ChatModel.fromMap(
                          snap.data() as Map<String, dynamic>));
                    } catch (e) {
                      log('Error : $e');
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        DateTime messageTime = chatList[index].time!.toDate();
                        String formattedTime =
                            DateFormat('h:mm a').format(messageTime);

                        var queryData = snapshot.data!.docs;
                        List chatsId = queryData.map((e) => e.id).toList();
                        if (chatList[index].isSeen == false &&
                            chatList[index].receiver ==
                                AuthService.authService
                                    .getCurrentUser()!
                                    .email) {
                          CloudFireStoreServices.cloudFireStoreServices
                              .updateMessageReadStatus(
                                  chatController.receiverEmail.value,
                                  chatsId[index]);
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Align(
                            alignment: chatList[index].sender ==
                                    AuthService.authService
                                        .getCurrentUser()!
                                        .email
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: chatList[index].sender ==
                                      AuthService.authService
                                          .getCurrentUser()!
                                          .email
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(1),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  constraints: BoxConstraints(
                                    maxWidth: size.width * 0.80,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: chatList[index].sender ==
                                              AuthService.authService
                                                  .getCurrentUser()!
                                                  .email
                                          ? [
                                              Colors.blueGrey[800]!,
                                              Colors.blueGrey[600]!
                                            ]
                                          : [
                                              Colors.blueGrey[200]!,
                                              Colors.blueGrey[400]!
                                            ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      topLeft: chatList[index].sender ==
                                              AuthService.authService
                                                  .getCurrentUser()!
                                                  .email
                                          ? Radius.circular(15)
                                          : Radius.zero,
                                      topRight: chatList[index].sender !=
                                              AuthService.authService
                                                  .getCurrentUser()!
                                                  .email
                                          ? Radius.circular(15)
                                          : Radius.zero,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      chatList[index].image!.isEmpty &&
                                              chatList[index].image! == ""
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13,
                                                  bottom: 25.0,
                                                  right: 70.0,
                                                  top: 3),
                                              child: Text(
                                                chatList[index].message!,
                                                style: TextStyle(
                                                  color: chatList[index]
                                                              .sender ==
                                                          AuthService
                                                              .authService
                                                              .getCurrentUser()!
                                                              .email
                                                      ? Colors.white
                                                      : Colors.black87,
                                                  fontSize: 13,
                                                ),
                                              ))
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: AspectRatio(
                                                  aspectRatio: 5 / 4,
                                                  child: Image.network(
                                                    chatList[index].image!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      Positioned(
                                        bottom: 2,
                                        right: 0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (chatList[index].isEdited)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 4.0),
                                                    child: Text(
                                                      "Edited ",
                                                      style: TextStyle(
                                                        color: chatList[index]
                                                                    .sender ==
                                                                AuthService
                                                                    .authService
                                                                    .getCurrentUser()!
                                                                    .email
                                                            ? Colors.grey[400]
                                                            : Colors.grey[200],
                                                        fontSize: 12,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                                Text(
                                                  formattedTime,
                                                  style: TextStyle(
                                                    color: Colors.grey[200],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CupertinoAlertDialog(
                                                          actions: [
                                                            CupertinoDialogAction(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Text("Copy"),
                                                            ),
                                                            CupertinoDialogAction(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Text("Info"),
                                                            ),
                                                            CupertinoDialogAction(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                if (chatList[index].sender == AuthService.authService.getCurrentUser()!.email) {
                                                                  // Directly call the dialog without Future.delayed
                                                                  chatController.txtUpdateMessage = TextEditingController(text: chatList[index].message);

                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return AlertDialog(
                                                                        title: Text(
                                                                          'Edit Message',
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: 18,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                        content: Container(
                                                                          width: 300,
                                                                          child: TextField(
                                                                            cursorColor: Colors.grey[700],
                                                                            controller: chatController.txtUpdateMessage,
                                                                            decoration: InputDecoration(
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                borderSide: BorderSide.none,
                                                                              ),
                                                                              fillColor: Colors.grey[200],
                                                                              filled: true,
                                                                              hintText: 'Enter your message here...',
                                                                              hintStyle: TextStyle(color: Colors.grey[600]),
                                                                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child: Text(
                                                                              'Cancel',
                                                                              style: TextStyle(color: Colors.blueAccent),
                                                                            ),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              String dcId = docIdList[index];
                                                                              Navigator.of(context).pop();
                                                                              CloudFireStoreServices.cloudFireStoreServices.updateChat(
                                                                                dcId,
                                                                                chatController.txtUpdateMessage.text,
                                                                                chatController.receiverEmail.value,
                                                                              );
                                                                              Get.back();
                                                                            },
                                                                            child: Text(
                                                                              'Edit',
                                                                              style: TextStyle(color: Colors.blueAccent),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(15.0),
                                                                        ),
                                                                        elevation: 5,
                                                                        backgroundColor: Colors.white,
                                                                      );
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                              child: Text("Edit"),
                                                            ),

                                                            CupertinoDialogAction(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'Delete Message'),
                                                                      content: Text(
                                                                          'Are you sure you want to delete this message?'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text('Cancel'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            CloudFireStoreServices.cloudFireStoreServices.removeChat(
                                                                              docIdList[index],
                                                                              chatController.receiverEmail.value,
                                                                            );
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text('Delete'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Text(
                                                                  "Delete"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    ;
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0),
                                                    child: chatList[index]
                                                                .sender ==
                                                            AuthService
                                                                .authService
                                                                .getCurrentUser()!
                                                                .email
                                                        ? Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: Colors
                                                                .grey[200],
                                                            size: 19,
                                                          )
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                (chatList[index].isSeen &&
                                        chatList[index].sender ==
                                            AuthService.authService
                                                .getCurrentUser()!
                                                .email)
                                    ? Icon(
                                        Icons.done_all_rounded,
                                        color: Colors.blue.shade400,
                                        size: 18,
                                      )
                                    : SizedBox(
                                        width: (chatList[index].isSeen &&
                                                chatList[index].sender ==
                                                    AuthService.authService
                                                        .getCurrentUser()!
                                                        .email)
                                            ? 5
                                            : 0,
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: chatController.txtMessage,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.image,
                              ),
                              onPressed: () async {
                                String url =
                                    await StorageService.service.uploadImage();
                                chatController.getImage(url);
                                print("photo pressed");
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blueGrey[900],
                      child: IconButton(
                        icon:
                            // chatController.isMessageEmpty.value
                            //     ? const Icon(Icons.image, color: Colors.white)
                            const Icon(Icons.send, color: Colors.white),
                        onPressed: () async {
                          if (!chatController.isMessageEmpty.value) {
                            ChatModel chat = ChatModel(
                              image: chatController.image.value,
                              sender: AuthService.authService
                                  .getCurrentUser()!
                                  .email,
                              receiver: chatController.receiverEmail.value,
                              message: chatController.txtMessage.text.trim(),
                              time: Timestamp.now(),
                            );
                            await CloudFireStoreServices.cloudFireStoreServices
                                .addChatInFireStore(chat);
                            LocalNotificationService.notificationService
                                .showNotification(
                              'New Message from ${AuthService.authService.getCurrentUser()!.email}',
                              chat.message!,
                            );
                            chatController.txtMessage.clear();
                            chatController.getImage("");
                          }
                        },
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildContainer() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Color(0xff11171d),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(chatController.receiverImage.value),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chatController.receiverName.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Active now",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: const Icon(CupertinoIcons.video_camera_solid,
                color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
