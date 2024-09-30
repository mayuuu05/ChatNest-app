import 'package:chatting_application/model/user_model.dart';
import 'package:chatting_application/services/auth_service.dart';
import 'package:chatting_application/services/cloud_firestore_service.dart';
import 'package:chatting_application/services/local_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/chat_controller.dart';
import '../../controller/tab_controller.dart';

var chatController = Get.put(ChatController());

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'ChatNest',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              LocalNotificationService.notificationService
                  .scheduleNotification();
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            color: Colors.white,
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String result) {
              switch (result) {
                case 'New group':
                  break;
                case 'New broadcast':
                  break;
                case 'Linked devices':
                  break;
                case 'Starred messages':
                  break;
                case 'Payments':
                  break;
                case 'Settings':
                  Get.toNamed('/pf');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'New group',
                child: Text('New group'),
              ),
              PopupMenuItem<String>(
                value: 'New broadcast',
                child: Text('New broadcast'),
              ),
              PopupMenuItem<String>(
                value: 'Linked devices',
                child: Text('Linked devices'),
              ),
              PopupMenuItem<String>(
                value: 'Starred messages',
                child: Text('Starred messages'),
              ),
              PopupMenuItem<String>(
                value: 'Payments',
                child: Text('Payments'),
              ),
              PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.08),
          child: FutureBuilder(
            future: CloudFireStoreServices.cloudFireStoreServices
                .readAllUserFromCloudFireStore(),
            builder: (context, snapshot) {
              int friendsCount = 0;
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                friendsCount = snapshot.data!.docs.length;
              }

              return TabBar(
                padding: EdgeInsets.zero,
                controller: controller.tabController,
                indicatorColor: Color(0xffF6A623),
                indicatorWeight: 3.0,
                labelColor: Color(0xffF6A623),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Chats'),
                        SizedBox(width: 5),
                        if (friendsCount > 0)
                          Flexible(
                            child: CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 10,
                              child: Text(
                                '$friendsCount',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Tab(text: 'Updates'),
                  Tab(text: 'Groups'),
                  Tab(text: 'Call'),
                ],
              );
            },
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          MessageList(),
          TransfersScreen(),
          GroupsScreen(),
          AddMoreScreen(),
        ],
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CloudFireStoreServices.cloudFireStoreServices
          .readAllUserFromCloudFireStore(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 28,
                  ),
                  title: Container(
                    height: 10.0,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  subtitle: Container(
                    height: 10.0,
                    width: double.infinity,
                    color: Colors.grey[200],
                  ),
                ),
              );
            },
          );
        }

        List data = snapshot.data!.docs;
        List<UserModel> userList = [];
        for (var user in data) {
          userList.add(UserModel.fromMap(user.data()));
        }

        return ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    chatController.getReceiver(
                      userList[index].email!,
                      userList[index].name!,
                      userList[index].image!,
                    );
                    Get.toNamed('/chat');
                  },
                  trailing: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: CloudFireStoreServices.cloudFireStoreServices
                        .getLastMessageStream(userList[index].email!),
                    builder: (context, messageSnapshot) {
                      if (messageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey,
                          child: Text(
                            '...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        );
                      }

                      if (messageSnapshot.hasError) {
                        return CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.error,
                            color: Colors.white,
                            size: 12,
                          ),
                        );
                      }

                      if (messageSnapshot.hasData &&
                          messageSnapshot.data!.docs.isNotEmpty) {
                        var messages = messageSnapshot.data!.docs;

                        int unreadCount = messages.where((messageDoc) {
                          var messageData = messageDoc.data();
                          bool isSentByCurrentUser = messageData['sender'] ==
                              AuthService.authService.getCurrentUser()!.email;
                          bool isSeen = messageData['isSeen'] ?? false;

                          return !isSentByCurrentUser && !isSeen;
                        }).length;

                        return unreadCount > 0
                            ? CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Text(
                            '$unreadCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        )
                            : SizedBox();
                      } else {
                        return Text("");
                      }
                    },
                  ),
                  title: Text(userList[index].name!),
                  subtitle: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: CloudFireStoreServices.cloudFireStoreServices
                        .getLastMessageStream(userList[index].email!),
                    builder: (context, messageSnapshot) {
                      if (messageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Text('Loading...');
                      }

                      if (messageSnapshot.hasError) {
                        return Text('Error: ${messageSnapshot.error}');
                      }

                      if (messageSnapshot.hasData &&
                          messageSnapshot.data!.docs.isNotEmpty) {
                        var messages = messageSnapshot.data!.docs;

                        int messageCount =
                        messages.length > 3 ? 3 : messages.length;
                        List<Widget> recentMessages = [];
                        for (int i = 0; i < messageCount; i++) {
                          String messageText =
                              messages[i]['message'] ?? 'No message';

                          recentMessages.add(
                            Text(
                              messageText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.04,
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: recentMessages,
                        );
                      } else {
                        return Text('');
                      }
                    },
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userList[index].image!),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}

class TransfersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Transfers Tab Content'),
    );
  }
}

class GroupsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Groups Tab Content'),
    );
  }
}

class AddMoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Add More Tab Content'),
    );
  }
}
