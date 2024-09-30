import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/cloud_firestore_service.dart';
import 'package:chatting_application/model/user_model.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            Get.back();
          }, icon: Icon(Icons.arrow_back, color: Colors.white)),
          backgroundColor: Colors.blueGrey[900],
          title: const Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder(
          future: CloudFireStoreServices.cloudFireStoreServices
              .readCurrentUserFromFireStore(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            Map? data = snapshot.data!.data();
            UserModel userModel = UserModel.fromMap(data!);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(userModel.image!),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 30),
                            onPressed: () {
                              // Logic to change the profile picture
                            },
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildEditableField(
                    context,
                    title: 'Name',
                    subtitle: userModel.name!,
                    icon: Icons.person,
                    onEdit: (String newValue) {
                      _showEditDialog(context, 'Edit Name', userModel.name!,
                              (newName) {
                            userModel.name = newName;
                          });
                    },
                  ),
                  const Divider(),
                  _buildEditableField(
                    context,
                    title: 'About',
                    subtitle: 'No status',
                    icon: Icons.info_outline,
                    onEdit: (String newValue) {
                      _showEditDialog(context, 'Edit About', '', (newAbout) {});
                    },
                  ),
                  const Divider(),
                  _buildEditableField(
                    context,
                    title: 'Phone',
                    subtitle: 'No phone number',
                    icon: Icons.phone,
                    onEdit: (String newValue) {
                      _showEditDialog(context, 'Edit Phone', '', (newPhone) {});
                    },
                  ),
                  const Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ListTile _buildEditableField(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Function(String) onEdit,
      }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF075E54)),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.edit, color: Color(0xFF075E54)),
      onTap: () {
        _showEditDialog(context, 'Edit $title', subtitle, onEdit);
      },
    );
  }

  void _showEditDialog(
      BuildContext context,
      String title,
      String currentValue,
      Function(String) onSave,
      ) {
    TextEditingController _controller = TextEditingController();
    _controller.text = currentValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter new value',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                onSave(_controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
