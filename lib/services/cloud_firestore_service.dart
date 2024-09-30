import 'package:chatting_application/model/chat_model.dart';
import 'package:chatting_application/model/user_model.dart';
import 'package:chatting_application/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';

class CloudFireStoreServices {
  CloudFireStoreServices._();

  static CloudFireStoreServices cloudFireStoreServices =
      CloudFireStoreServices._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> insertUserIntoFireStore(UserModel user) async {
    await fireStore.collection("users").doc(user.email).set({
      'name': user.name,
      'email': user.email,
      'image': user.image,
      'phone': user.phone,
      'token': user.token,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>
      readCurrentUserFromFireStore() async {
    User? user = AuthService.authService.getCurrentUser();
    return await fireStore.collection("users").doc(user!.email).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>>
      readAllUserFromCloudFireStore() async {
    User? user = AuthService.authService.getCurrentUser();
    return await fireStore
        .collection("users")
        .where("email", isNotEqualTo: user!.email)
        .get();
  }

  Future<void> addChatInFireStore(ChatModel chat) async {
    String? sender = chat.sender;
    String? receiver = chat.receiver;

    List<String?> doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .add(chat.toMap(chat));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readChatFromFireStore(
      String receiver,) {
    String sender = AuthService.authService.getCurrentUser()!.email!;
    List<String?> doc = [sender, receiver];
    doc.sort();

    String docId = doc.join("_");

    return fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .orderBy('time', descending: false)
        .snapshots();
  }

  Future<void> updateChat(String dcId, String message, String receiver) async {
    String sender = AuthService.authService.getCurrentUser()!.email!;
    List<String?> doc = [sender, receiver];
    doc.sort();

    String docId = doc.join("_");
    await fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(dcId)
        .update({
      'message': message,
      'isEdited': true,
    });
  }

  Future<void> removeChat(String dcId, String receiver) async {
    String sender = AuthService.authService.getCurrentUser()!.email!;
    List<String?> doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");

    await fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(dcId)
        .delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessageStream(
      String receiver) {
    String sender = AuthService.authService.getCurrentUser()!.email!;
    List<String?> doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");

    return fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .orderBy('time', descending: true)
        .limit(1)
        .snapshots();
  }


  Future<void> markMessageAsSeen(String docId, String receiver) async {
    String sender = AuthService.authService.getCurrentUser()!.email!;
    List<String?> doc = [sender, receiver];
    doc.sort();
    String chatDocId = doc.join("_");

    await fireStore
        .collection("chatroom")
        .doc(chatDocId)
        .collection("chat")
        .doc(docId)
        .update({
      'isSeen': true,
    });
  }

  ChatController chatController = Get.put(ChatController());

  void updateMessageReadStatus(String receiver, String chatId) {
    List<String> doc = [
      AuthService.authService.getCurrentUser()!.email!,
      receiver
    ];
    doc.sort();
    String docId = doc.join('_');

    chatController.callId.value = docId;
    fireStore
        .collection('chatroom')
        .doc(docId)
        .collection('chat')
        .doc(chatId)
        .update({'isSeen': true});
  }
}
