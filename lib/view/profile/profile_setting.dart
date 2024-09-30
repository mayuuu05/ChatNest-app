import 'package:chatting_application/model/user_model.dart';
import 'package:chatting_application/services/cloud_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../services/google_auth_service.dart';

class ProfileSetting extends StatelessWidget {
  const ProfileSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          backgroundColor: Colors.blueGrey[900],
          title: const Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                )),
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ListView(
            children: [
              _buildProfileHeader(),
              const Divider(),
              _buildSettingsItem(
                title: 'Account',
                subtitle: 'Security notifications, change number',
                icon: Icons.key,
                onTap: () {},
              ),
              _buildSettingsItem(
                title: 'Privacy',
                subtitle: 'Block contacts, disappearing messages',
                icon: Icons.lock,
                onTap: () {},
              ),
              _buildSettingsItem(
                title: 'Avatar',
                subtitle: 'Create, edit, profile photo',
                icon: Icons.face,
                onTap: () {},
              ),
              _buildSettingsItem(
                title: 'Favorites',
                subtitle: 'Add, reorder, remove',
                icon: Icons.favorite,
                onTap: () {},
              ),
              _buildSettingsItem(
                title: 'Chats',
                subtitle: 'Theme, wallpapers, chat history',
                icon: Icons.chat,
                onTap: () {},
              ),
              _buildSettingsItem(
                title: 'Notifications',
                subtitle: 'Message, group & call tones',
                icon: Icons.notifications,
                onTap: () {},
              ),
              _buildSettingsItem(
                title: 'Storage and data',
                subtitle: 'Network usage, auto download',
                icon: Icons.storage,
                onTap: () {},
              ),
              _buildSettingsItem(
                title: 'App language',
                subtitle: 'English (device\'s language)',
                icon: Icons.language,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return FutureBuilder(
      future: CloudFireStoreServices.cloudFireStoreServices
          .readCurrentUserFromFireStore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        Map? data = snapshot.data!.data();
        UserModel userModel = UserModel.fromMap(data!);

        return ListTile(
          leading: GestureDetector(
            onTap: () {
              Get.toNamed("/ed_Pf");
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(userModel.image!),
            ),
          ),
          title: Text(
            userModel.name!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text("Hey there! I am using this app."),
          trailing: IconButton(
            icon: const Icon(Icons.qr_code_2),
            onPressed: () {},
          ),
          onTap: () {},
        );
      },
    );
  }

  ListTile _buildSettingsItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey[900]),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 14)),
      onTap: onTap,
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Logout'),
            onPressed: () async {
              Navigator.of(context).pop();
              await AuthService.authService.signOutYourAccount();
              await GoogleAuthService.googleAuthService.signOutFromGoogle();
              User? user = AuthService.authService.getCurrentUser();
              if (user == null) {
                Get.offAndToNamed('/signin');
              }
            },
          ),
        ],
      );
    },
  );
}
